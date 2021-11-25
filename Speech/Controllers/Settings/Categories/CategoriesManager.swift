//
//  CategoriesManager.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 25/11/2021.
//

import UIKit

protocol CategoriesManager: AbstractViewController {
    
}

extension CategoriesManager {
    func onEdit(category: Category) {
        let vc = CategoryViewController(viewModel: .init(mode: .edition(category: category)))
        present(NavigationController(rootViewController: vc))
    }
    
    func onDelete(category: Category) {
        self.showCategoryDeleteAlert(onCompletion: { shouldDelete in
            if shouldDelete {
                #warning("Add in a viewModel")
                RealmService().delete(category: category)
            }
        })
    }
    
    func showCategoryDeleteAlert(onCompletion: @escaping ((Bool) -> Void)) {
        let alertViewController = UIAlertController(title: SwiftyAssets.Strings.category_delete_confirmation_title,
                                                    message: SwiftyAssets.Strings.category_delete_confirmation_message,
                                                    preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: SwiftyAssets.Strings.generic_delete, style: .destructive) { _ in
            onCompletion(true)
        }
        let cancelAction = UIAlertAction(title: SwiftyAssets.Strings.generic_cancel, style: .cancel) { _ in
            onCompletion(false)
        }
        
        alertViewController.addAction(deleteAction)
        alertViewController.addAction(cancelAction)
        
        present(alertViewController)
    }
}
