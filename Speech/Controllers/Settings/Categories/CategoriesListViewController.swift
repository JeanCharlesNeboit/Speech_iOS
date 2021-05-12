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

class CategoriesListViewController: BaseListViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var addButton: Button! {
        didSet {
            addButton.setTitle(SwiftyAssets.Strings.generic_add)
            addButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.present(NavigationController(rootViewController: NewCategoryViewController(parentCategory: self.parentCategory)))
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    private lazy var searchController = SearchController()
    
    @RxBehaviorSubject private var categories = [Category]()
    private var parentCategory: Category?
    private var onSelection: ((Category) -> Void)?

    // MARK: - Initialization
    init(parentCategory: Category? = nil) {
        self.parentCategory = parentCategory
        super.init()
    }
    
    init(onSelection: @escaping ((Category) -> Void)) {
        self.onSelection = onSelection
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.generic_categories
    }

    // MARK: - Configure
    override func configure() {
        super.configure()
        navigationItem()
        configureTableView()
    }

    private func navigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        tableView.rx.modelSelected(BaseListCellType.self)
            .subscribe(onNext: { [weak self] cellType in
                guard let self = self else { return }
                guard case let .category(category) = cellType else { return }
                if let onSelection = self.onSelection {
                    onSelection(category)
                } else {
                    self.navigationController?.pushViewController(CategoriesListViewController(parentCategory: category), animated: true)
                }
            }).disposed(by: disposeBag)
        
        let searchTextObservable = searchController.searchBar.rx.text.asObservable()
        let categoriesResultsObservable = Observable.collection(from: realmService.getCategoriesResult(parentCategory: parentCategory))
        Observable.combineLatest(searchTextObservable, categoriesResultsObservable)
            .subscribe { search, categoriesResult in
                let categories = categoriesResult.toArray()
                    .filter { category in
                        guard let search = search,
                              !search.trimmingCharacters(in: .whitespaces).isEmpty else { return true }
                        return category.name.contains(search)
                    }
                self.categories = categories.sorted()
            }.disposed(by: disposeBag)
        
        $categories
            .subscribe(onNext: { [weak self] categories in
                guard let self = self else { return }
                self.sections = [
                    Section.init(model: .init(header: self.parentCategory?.name), items:
                        categories.map {
                            return .category($0)
                        }
                    )
                ]
            }).disposed(by: disposeBag)
    }
}

extension CategoriesListViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: SwiftyAssets.Strings.generic_delete) { [weak self] _, _, _ in
            guard let self = self else { return }
            guard let category = self.categories[safe: indexPath.row] else { return }
            self.realmService.deleteObject(category)
        }
        
        let editAction = UIContextualAction(style: .normal, title: SwiftyAssets.Strings.generic_edit) { [weak self] _, _, success in
            guard let self = self else { return }
            guard let category = self.categories[safe: indexPath.row] else { return }
            //self.present(NavigationController(rootViewController: NewCategoryViewController()))
            success(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}
