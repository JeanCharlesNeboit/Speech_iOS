//
//  CategoriesViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit
import SwiftyKit
import RxSwift
import RxDataSources

class CategoriesViewController: AbstractViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: TableView! {
        didSet {
            let cells: [CellIdentifiable.Type] = [DetailsTableViewCell.self]
            cells.forEach {
                tableView.register($0.nib, forCellReuseIdentifier: $0.identifier)
            }
        }
    }
    
    @IBOutlet weak var addButton: UIButton! {
        didSet {
            addButton.setImage(SwiftyAssets.Images.plus_circle_fill.withRenderingMode(.alwaysTemplate), for: .normal)
            addButton.rx.tap
                .subscribe(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.onAddButtonTap()
                }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    private var categoriesObservable = BehaviorSubject<[Category]>(value: [])
    
    // MARK: - Initialization
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
        navigationItem.searchController = SearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
//        let searchTextObservable = searchController.searchBar.rx.text.asObservable()
//        let categoriesResultsObservable = Observable.collection(from: realmService.getCategoriesResult())
//        Observable.combineLatest(categoriesResultsObservable)
//            .map { search, messagesResult, orderMode -> [Message] in
//                var messages = messagesResult.toArray()
//                    .filter { message in
//                        guard let search = search,
//                              !search.trimmingCharacters(in: .whitespaces).isEmpty else { return true }
//                        return message.text?.contains(search) ?? false
//                    }
//                
//                switch orderMode {
//                case .alphabetical:
//                    messages = messages.sortedByAlphabeticalOrder()
//                case .addedDate:
//                    messages = messages.sortedByAddedDateOrder()
//                }
//                
//                return messages
//            }
        
        Observable.collection(from: realmService.getCategoriesResult())
            .map {
                $0.toArray()
            }.bind(to: categoriesObservable)
            .disposed(by: disposeBag)
        
        categoriesObservable
            .bind(to: tableView.rx.items(cellIdentifier: DetailsTableViewCell.identifier, cellType: DetailsTableViewCell.self)) { _, category, cell in
                cell.configure(title: category.name)
            }.disposed(by: disposeBag)
    }
    
    // MARK: -
    private func onAddButtonTap() {
        let alertController = UIAlertController(title: "Nouvelle catégorie*", message: nil, preferredStyle: .alert)
        
        var categoryTextField: UITextField?
        alertController.addTextField { textField in
            textField.placeholder = "Nom*"
            categoryTextField = textField
        }
        
        let cancelAction = UIAlertAction(title: SwiftyAssets.Strings.generic_cancel, style: .cancel)
        let validateAction = UIAlertAction(title: SwiftyAssets.Strings.generic_validate, style: .default) { _ in
            if let name = categoryTextField?.text.strongValue,
               !name.isEmpty {
                let category = Category(name: name)
                self.realmService.addObject(category)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(validateAction)
        present(alertController, animated: true, completion: nil)
    }
}
