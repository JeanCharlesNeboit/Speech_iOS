//
//  CategoriesListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit
import SwiftyKit
import RxSwift
import RxDataSources
import RxKeyboard

class CategoriesListViewController: BaseListViewController {
    typealias ViewModel = CategoriesListViewModel
    
    enum EmptyMode {
        case category
        case subCategory(category: Category)
        case search
        
        var title: String {
            switch self {
            case .category:
                return SwiftyAssets.Strings.categories_list_empty_title
            case .subCategory(let category):
                return category.nameWithEmoji
            case .search:
                return SwiftyAssets.Strings.search_empty_title
            }
        }
        
        var body: String {
            switch self {
            case .category:
                return SwiftyAssets.Strings.categories_list_empty_body
            case .subCategory:
                return SwiftyAssets.Strings.sub_categories(count: 0)
            case .search:
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
    
    @IBOutlet weak var addButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButton: PrimaryButton! {
        didSet {
            addButton.setTitle(SwiftyAssets.Strings.generic_add)
            addButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    let vc = CategoryViewController(viewModel: .init(mode: .creation(parentCategory: self.viewModel.parentCategory)))
                    let nav = NavigationController(rootViewController: vc)
                    self.present(nav)
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    static let title = SwiftyAssets.Strings.generic_categories
    let viewModel: ViewModel
    
    private lazy var emptyView: EmptyView = .loadFromXib()
    
    private lazy var selectBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Use*", style: .done, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            if case .selection(let onSelection) = self.viewModel.mode,
               let category = self.viewModel.parentCategory {
                onSelection(category)
            }
            
        }).disposed(by: disposeBag)
        return button
    }()

    // MARK: - Initialization
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sharedInit() {
        super.sharedInit()
        title = Self.title
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    // MARK: - Observe
    private func observeSections() {
        viewModel.$categories
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = $0.isEmpty
                self.emptyContainerView.isHidden = !$0.isEmpty
            }).disposed(by: disposeBag)
    }

    // MARK: - Configure
    override func configure() {
        super.configure()
        observeSections()
        configureNavigationItem()
        configureSearch()
        configureTableView()
        configureKeyboard()
    }

    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        if case .selection = viewModel.mode,
           viewModel.parentCategory != nil {
            navigationItem.rightBarButtonItem = selectBarButtonItem
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
                    self.configureEmptyView(mode: .search)
                } else {
                    var mode: EmptyMode = .category
                    if let category = self.viewModel.parentCategory {
                        mode = .subCategory(category: category)
                    }
                    self.configureEmptyView(mode: mode)
                }
            }).disposed(by: disposeBag)
    }
    
    private func configureEmptyView(mode: EmptyMode) {
        emptyView.configure(image: SwiftyAssets.UIImages.folder,
                            title: mode.title,
                            body: mode.body)
    }
    
    private func configureTableView() {
        tableView.rx.modelSelected(BaseListCellType.self)
            .subscribe(onNext: { [weak self] cellType in
                guard let self = self else { return }
                guard case let .category(_category, _) = cellType,
                      let category = _category else { return }
                
                let showSubCategories = {
                    let vc = CategoriesListViewController(viewModel: .init(parentCategory: category, mode: self.viewModel.mode))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
                switch self.viewModel.mode {
                case .edition:
                    showSubCategories()
                case .selection(let onSelection):
                    if category.subCategories.isEmpty {
                        onSelection(category)
                    } else {
                        showSubCategories()
                    }
                }
            }).disposed(by: disposeBag)
        
        viewModel.$categories
            .subscribe(onNext: { [weak self] categories in
                guard let self = self else { return }
                self.sections = [
                    Section.init(model: .init(header: self.viewModel.parentCategory?.name), items:
                        categories.map { category in
                            return .category(category) { cell in
                                if #available(iOS 13, *) {
                                    let interaction = ContextMenuInteraction<Category>(item: category, delegate: self)
                                    cell.addInteraction(interaction)
                                }
                            }
                        }
                    )
                ]
            }).disposed(by: disposeBag)
    }
    
    override func configureKeyboard() {
        RxKeyboard.instance.visibleHeight
            .asObservable()
            .subscribe(onNext: { [weak self] height in
                guard let self = self else { return }
                #warning("Update to additional safe area insets & merge with super view configureKeyboard")
                let keyboardBottomContentInset = height - self.view.safeAreaInsets.bottom
                let buttonBottomContentInset = UIView.getBottomContentInset(view: self.addButton, bottomConstraint: self.addButtonBottomConstraint)
                self.tableView.setBottomContentInset(max(keyboardBottomContentInset, buttonBottomContentInset))
            }).disposed(by: disposeBag)
    }
}

extension CategoriesListViewController: CategoriesManager {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: SwiftyAssets.Strings.generic_delete) { [weak self] _, _, completion in
            guard let self = self else { return }
            guard let category = self.viewModel.categories[safe: indexPath.row] else { return }
            self.onDelete(category: category)
            completion(true)
        }
        
        let editAction = UIContextualAction(style: .normal, title: SwiftyAssets.Strings.generic_edit) { [weak self] _, _, completion in
            guard let self = self else { return }
            guard let category = self.viewModel.categories[safe: indexPath.row] else { return }
            self.onEdit(category: category)
            completion(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}

@available(iOS 13.0, *)
extension CategoriesListViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        if let categoryInteraction = interaction as? ContextMenuInteraction<Category> {
            return UIContextMenuConfiguration.MakeCategoryContextMenuConfiguration(category: categoryInteraction.item, manager: self)
        }
        return nil
    }
}

@available(iOS 13.0, *)
extension UIContextMenuConfiguration {
    static func MakeCategoryContextMenuConfiguration(category: Category, manager: CategoriesManager) -> UIContextMenuConfiguration {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let edit = UIAction(title: SwiftyAssets.Strings.generic_edit, image: UIImage(systemName: "square.and.pencil")) { _ in
                manager.onEdit(category: category)
            }
        
            let delete = UIAction(title: SwiftyAssets.Strings.generic_delete, image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                manager.onDelete(category: category)
            }
        
            return UIMenu(title: "", children: [edit, delete])
        }
    }
}
