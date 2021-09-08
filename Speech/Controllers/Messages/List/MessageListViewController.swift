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
import RxKeyboard

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
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var emptyContainerView: UIView! {
        didSet {
            emptyContainerView.addSubview(emptyView)
            emptyView.edgesToSuperview()
        }
    }
    
    // MARK: - Properties
    let viewModel: ViewModel
    let gridColumn = 2
    
    private lazy var layoutModeBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(image: DefaultsStorage.preferredMessageDisplayMode.image, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            DefaultsStorage.preferredMessageDisplayMode = DefaultsStorage.preferredMessageDisplayMode == .list ? .grid : .list
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var moreBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(image: SwiftyAssets.UIImages.ellipsis_circle, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            SortMode.allCases.forEach { sortMode in
                let title = sortMode.name + (sortMode == self.viewModel.sortMode ? " ✔︎" : "")
                let action = UIAlertAction(title: title, style: .default, handler: { _ in
                    self.viewModel.sortMode = sortMode
                })
                alertController.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: SwiftyAssets.Strings.generic_cancel, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let popover = alertController.popoverPresentationController
            popover?.barButtonItem = button
            
            self.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var searchController: SearchController = {
        let searchController = SearchController(searchResultsController: nil)
        if !isCollapsed {
            searchController.searchBar.inputAccessoryView = EditorAreaToolbar.shared
        }
        return searchController
    }()
    
    private lazy var listTableView: TableView = {
        let tableView = TableView()
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var gridTableView: TableView = {
        let tableView = TableView(style: .grouped)
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        return tableView
    }()
    
    private lazy var emptyView: EmptyView = .loadFromXib()

    // MARK: - Initialization
    init(viewModel: ViewModel = .init()) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.generic_messages
        definesPresentationContext = true
        navigationItem.rightBarButtonItems = [moreBarButtonItem, layoutModeBarButtonItem]
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
        viewModel.$messageSections
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.listTableView.isHidden = $0.isEmpty
                self.emptyContainerView.isHidden = !$0.isEmpty
            }).disposed(by: disposeBag)
    }
    
    private func observeDisplayMode() {
        DefaultsStorage.$preferredMessageDisplayMode.subscribe(onNext: { [weak self] mode in
            guard let self = self else { return }
            self.layoutModeBarButtonItem.image = mode.image
            self.contentStackView.removeAllArrangedSubviews()
            switch mode {
            case .list:
                self.contentStackView.addArrangedSubview(self.listTableView)
            case .grid:
                self.contentStackView.addArrangedSubview(self.gridTableView)
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Configure
    override func configure() {
        super.configure()
        observeSections()
        observeDisplayMode()
        configureSearch()
        configureTableView()
        configureCollectionView()
        configureKeyboard()
    }
    
    private func updateNavigationItem() {
        navigationItem.leftBarButtonItem = isCollapsed ? cancelBarButtonItem : nil
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
    
    private func configureTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<ViewModel.MessageSection>(configureCell: { _, tableView, indexPath, message in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(message: message, layout: .horizontal)
            return cell
        }, titleForHeaderInSection: { sections, indexPath -> String? in
            return sections.sectionModels[indexPath].model.header
        })
        
        viewModel.$messageSections
            .bind(to: listTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        listTableView.rx.modelSelected(Message.self)
            .subscribe(onNext: { [weak self] message in
                guard let self = self,
                      case let message = message else { return }
                self.viewModel.onTap(message: message)
            }).disposed(by: disposeBag)
    }
    
    private func configureCollectionView() {
        let dataSource = RxTableViewSectionedReloadDataSource<ViewModel.GridSection>(configureCell: { _, tableView, indexPath, categories in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessagesTableViewCell.identifier, for: indexPath) as? MessagesTableViewCell else {
                return UITableViewCell()
            }
            let isLast = indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1
            cell.configure(categories: categories, column: self.gridColumn, isLast: isLast)
            cell.onCategoryTap = { [weak self] category in
                #warning("Todo")
                self?.navigationController?.pushViewController(MessageListViewController(), animated: true)
            }
            return cell
        }, titleForHeaderInSection: { sections, indexPath -> String? in
            return sections.sectionModels[indexPath].model.header
        })
        
        viewModel.$categorySections
            .map { section in
                section.map {
                    ViewModel.GridSection.init(model: $0.model, items: $0.items.chunked(into: self.gridColumn))
                }
            }
            .bind(to: gridTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func configureKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.listTableView.contentInset.bottom = keyboardVisibleHeight
                self?.listTableView.scrollIndicatorInsets.bottom = keyboardVisibleHeight
            }).disposed(by: disposeBag)
    }
    
    private func configureEmptyView(mode: EmptyMode) {
        emptyView.configure(image: SwiftyAssets.UIImages.folder,
                            title: mode.title,
                            body: mode.body)
    }
}

extension MessageListViewController: UITableViewDelegate {    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard tableView == listTableView else {
            // return empty UISwipeActionsConfiguration instead of nil, because nil create delete action automatically !
            return UISwipeActionsConfiguration()
        }
        guard let message = self.viewModel.messageSections[safe: indexPath.section]?.items[safe: indexPath.row] else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: SwiftyAssets.Strings.generic_delete) { [weak self] _, _, _ in
            guard let self = self else { return }
            self.viewModel.onDelete(message: message)
        }
//        deleteAction.image = SwiftyAssets.Images.gearshape
        
        let editAction = UIContextualAction(style: .normal, title: SwiftyAssets.Strings.generic_edit) { [weak self] _, _, success in
            guard let self = self else { return }
            self.present(NavigationController(rootViewController: MessageViewController(viewModel: .init(mode: .edition(message: message)))))
            success(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}
