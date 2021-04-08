//
//  SearchController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit

class SearchController: UISearchController {
    // MARK: - Properties
    var searchText: String? {
        let searchText = searchBar.text.strongValue
        guard !searchText.isEmpty else { return nil }
        return searchText
    }
    
    // MARK: - Initialization
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        sharedInit()
    }
    
    override init(searchResultsController: UIViewController? = nil) {
        super.init(searchResultsController: searchResultsController)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    func sharedInit() {
        searchBar.searchBarStyle = .minimal
        dimsBackgroundDuringPresentation = false
    }
}
