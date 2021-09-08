//
//  Searchable.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/09/2021.
//

protocol Searchable {
    var searchText: String { get }
}

extension Collection where Iterator.Element: Searchable {
    func filter(search: String?) -> [Element] {
        filter { item in
            guard !search.isEmptyOrNil,
                  let search = search else { return true }
            return item.searchText.uppercased().contains(search.uppercased())
        }
    }
}
