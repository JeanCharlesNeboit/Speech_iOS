//
//  CategoriesListViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/07/2021.
//

import Foundation
import RxSwift

class CategoriesListViewModel: AbstractViewModel {
    enum Mode {
        case edition
        case selection(((Category) -> Void))
    }
    
    // MARK: - Properties
    @RxBehaviorSubject var search: String?
    @RxBehaviorSubject private(set) var categories = [Category]()
    
    private(set) var parentCategory: Category?
    let mode: Mode
    
    // MARK: - Initialization
    init(parentCategory: Category?,
         mode: Mode) {
        self.parentCategory = parentCategory
        self.mode = mode
        super.init()
        
        let categoriesResultsObservable = Observable.collection(from: realmService.getCategories(parent: parentCategory))
        Observable.combineLatest($search, categoriesResultsObservable)
            .subscribe { search, categoriesResult in
                let categories = categoriesResult.toArray()
                    .filter { category in
                        guard let search = search,
                              !search.trimmingCharacters(in: .whitespaces).isEmpty else { return true }
                        return category.name.uppercased().contains(search.uppercased())
                    }
                self.categories = categories.sorted()
            }.disposed(by: disposeBag)
    }
    
    // MARK: -
    func onDelete(category: Category) {
        realmService.deleteObject(category)
    }
}
