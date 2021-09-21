//
//  Sortable.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 21/09/2021.
//

import Foundation

protocol Sortable: Searchable {
    var addedDate: Date { get }
}

// swiftlint:disable force_cast
extension Collection where Iterator.Element: Sortable {
    func sortedByAlphabeticalOrder<T: Sortable>() -> [T] {
        sorted(by: { lhs, rhs -> Bool in
            lhs.searchText.diacriticInsensitive < rhs.searchText.diacriticInsensitive
        }) as! [T]
    }
    
    func sortedByAddedDateOrder<T: Sortable>() -> [T] {
        sorted(by: { lhs, rhs -> Bool in
            lhs.addedDate > rhs.addedDate
        }) as! [T]
    }
}
// swiftlint:enable force_cast
