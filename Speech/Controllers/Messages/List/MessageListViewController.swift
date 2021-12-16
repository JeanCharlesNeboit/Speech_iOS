//
//  MessageListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import SwiftyKit
import RxSwift
import RxDataSources
import RealmSwift

class MessageListViewController: AbstractViewController {
    // MARK: - Typealias
    typealias ViewModel = MessageListViewModel
    
    // MARK: - Enums
    enum DisplayMode: Int {
        case list
        case grid
        
        var image: UIImage {
            switch self {
            case .list:
                return SwiftyAssets.UIImages.square_grid_2x2
            case .grid:
                return SwiftyAssets.UIImages.rectangle_grid_1x2
            }
        }
    }
    
    enum EmptyMode {
        case noData
        case noResult
        
        var title: String {
            switch self {
            case .noData:
                return SwiftyAssets.Strings.messages_list_empty_title
            case .noResult:
                return SwiftyAssets.Strings.search_empty_title
            }
        }
        
        var body: String {
            switch self {
            case .noData:
                return SwiftyAssets.Strings.messages_list_empty_body
            case .noResult:
                return SwiftyAssets.Strings.search_empty_body
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var emptyContainerView: UIView! {
        didSet {
            emptyContainerView.addSubview(emptyView)
            emptyView.edgesToSuperview()
        }
    }
    
    // MARK: - Properties
    let viewModel: ViewModel
    
    private(set) lazy var layoutModeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(image: viewModel.preferredMessageDisplayMode.image, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.preferredMessageDisplayMode = self.viewModel.preferredMessageDisplayMode == .list ? .grid : .list
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var moreBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(image: SwiftyAssets.UIImages.ellipsis_circle, style: .plain, target: nil, action: nil)
        return button
    }()
    
    private lazy var tableView: TableView = {
        let tableView = TableView()
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var emptyView: EmptyView = .loadFromXib()
    
    // MARK: - Initialization
    init(viewModel: ViewModel = .init(category: nil)) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sharedInit() {
        super.sharedInit()
        title = viewModel.category?.name ?? SwiftyAssets.Strings.generic_messages
        definesPresentationContext = true
        
        navigationItem.rightBarButtonItems = [moreBarButtonItem]
        if viewModel.category == nil {
            navigationItem.rightBarButtonItems?.append(layoutModeBarButtonItem)
        }
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationItem()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateNavigationItem()
    }
    
    // MARK: - Observe
    private func observeSections() {
        viewModel.$sections
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = $0.isEmpty
                self.emptyContainerView.isHidden = !$0.isEmpty
            }).disposed(by: disposeBag)
    }
    
    private func observeDisplayMode() {
        viewModel.$preferredMessageDisplayMode.subscribe(onNext: { [weak self] mode in
            guard let self = self else { return }
            self.layoutModeBarButtonItem.image = mode.image
//            self.tableView.separatorStyle = mode == .list ? .singleLine : .none
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    override func configure() {
        super.configure()
        view.insertSubview(tableView, at: 0)
        tableView.edgesToSuperview()
        
        observeSections()
        observeDisplayMode()
        
        configureMoreBarButtonAction()
        configureSearch()
        configureKeyboard()
        configureCollectionView()
    }
    
    private func updateNavigationItem() {
        let isPushed = navigationController?.viewControllers.count ?? 0 > 1
        navigationItem.leftBarButtonItem = isCollapsed && !isPushed ? cancelBarButtonItem : nil
    }
    
    private func configureMoreBarButtonAction() {
        if #available(iOS 14, *) {
            Observable.combineLatest(viewModel.$sortMode, viewModel.$showFrequentlyUsedMessages)
                .subscribe(onNext: { [weak self] sortMode, showFrequentlyUsedMessages in
                    guard let self = self else { return }
                    
                    let showFrequentlyAction = UIAction(title: showFrequentlyUsedMessages ? SwiftyAssets.Strings.hide_frequently_used_messages : SwiftyAssets.Strings.show_frequently_used_messages,
                                                        image: showFrequentlyUsedMessages ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")) { _ in
                        self.viewModel.showFrequentlyUsedMessages.toggle()
                    }
                    
                    let sortModeMenu = UIMenu(title: "", options: .displayInline, children: SortMode.allCases.map { sortMode in
                        UIAction(title: sortMode.name,
                                 image: sortMode.image,
                                 state: sortMode == self.viewModel.sortMode ? .on : .off,
                                 handler: { _ in
                            self.viewModel.sortMode = sortMode
                        })
                    })
                    
                    let children = [sortModeMenu, showFrequentlyAction]
                    self.moreBarButtonItem.menu = UIMenu(title: "", children: children)
                }).disposed(by: disposeBag)
        } else {
            moreBarButtonItem.rx.tap.subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                SortMode.allCases.forEach { sortMode in
                    let title = (sortMode == self.viewModel.sortMode ? "✔︎ " : "") + sortMode.name
                    let action = UIAlertAction(title: title, style: .default, handler: { _ in
                        self.viewModel.sortMode = sortMode
                    })
                    alertController.addAction(action)
                }
                
                let cancelAction = UIAlertAction(title: SwiftyAssets.Strings.generic_cancel, style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                
                let popover = alertController.popoverPresentationController
                popover?.barButtonItem = self.moreBarButtonItem
                
                self.present(alertController, animated: true)
            }).disposed(by: disposeBag)
        }
    }
    
    private func configureSearch() {
        searchController.searchBar.rx.text
            .bind(to: viewModel.$search)
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.asObservable()
            .subscribe(onNext: { [weak self] search in
                guard let self = self else { return }
                if !search.strongValue.isEmpty {
                    self.configureEmptyView(mode: .noResult)
                } else {
                    self.configureEmptyView(mode: .noData)
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureCollectionView() {
        let dataSource = RxTableViewSectionedReloadDataSource<ViewModel.Section>(configureCell: { [self] _, tableView, indexPath, dataSource in
            let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            
            switch dataSource {
            case .message(let message):
                guard let cell: MessageTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
                    return UITableViewCell()
                }
                cell.configure(message: message, layout: .horizontal, isLast: isLast)
                
                if #available(iOS 13, *) {
                    let interaction = ContextMenuInteraction<Message>(item: message, delegate: self)
                    cell.addInteraction(interaction)
                }
                
                return cell
            case .categories(let categories):
                guard let cell: CategoriesTableViewCell = tableView.dequeueReusableCell(for: indexPath) else {
                    return UITableViewCell()
                }
                cell.configure(categories: categories, column: self.viewModel.gridColumn, isLast: isLast) { categoryView, category in
                    if #available(iOS 13, *) {
                        let interaction = ContextMenuInteraction<Category>(item: category, delegate: self)
                        categoryView.addInteraction(interaction)
                    }
                }
                cell.onCategoryTap = { [weak self] category in
                    let vc = MessageListViewController(viewModel: .init(category: category))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
                return cell
            }
        }, titleForHeaderInSection: { sections, indexPath -> String? in
            return sections.sectionModels[indexPath].model.header
        })
        
        viewModel.$sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ViewModel.DataSource.self)
            .subscribe(onNext: { [weak self] dataSource in
                guard let self = self else { return }
                switch dataSource {
                case .message(let message):
                    self.viewModel.onTap(message: message)
                    if UIDevice.current.isPhone,
                       DefaultsStorage.closeMessageViewWhenMessageSelected {
                        self.dismiss(animated: true, completion: nil)
                    }
                case .categories:
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureEmptyView(mode: EmptyMode) {
        emptyView.configure(image: SwiftyAssets.UIImages.folder,
                            title: mode.title,
                            body: mode.body)
    }
}

extension MessageListViewController: UITableViewDelegate {
    private func onEdit(message: Message) {
        present(NavigationController(rootViewController: MessageViewController(viewModel: .init(mode: .edition(message: message)))))
    }
    
    private func onDelete(message: Message) {
        viewModel.onDelete(message: message)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let dataSouce = self.viewModel.sections[safe: indexPath.section]?.items[safe: indexPath.row]
        guard case .message(let message) = dataSouce else {
            // return empty UISwipeActionsConfiguration instead of nil, because nil create delete action automatically !
            return UISwipeActionsConfiguration()
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: SwiftyAssets.Strings.generic_delete) { [weak self] _, _, _ in
            self?.onDelete(message: message)
        }
        
        let editAction = UIContextualAction(style: .normal, title: SwiftyAssets.Strings.generic_edit) { [weak self] _, _, success in
            self?.onEdit(message: message)
            success(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}

@available(iOS 13.0, *)
extension MessageListViewController: UIContextMenuInteractionDelegate, CategoriesManager {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        if let messageInteraction = interaction as? ContextMenuInteraction<Message> {
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
                let edit = UIAction(title: SwiftyAssets.Strings.generic_edit, image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
                    self?.onEdit(message: messageInteraction.item)
                }
                
                let delete = UIAction(title: SwiftyAssets.Strings.generic_delete, image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                    self?.onDelete(message: messageInteraction.item)
                }
                
                return UIMenu(title: "", children: [edit, delete])
            }
        } else if let categoryInteraction = interaction as? ContextMenuInteraction<Category> {
            return UIContextMenuConfiguration.MakeCategoryContextMenuConfiguration(category: categoryInteraction.item, manager: self)
        }
        return nil
    }
}
