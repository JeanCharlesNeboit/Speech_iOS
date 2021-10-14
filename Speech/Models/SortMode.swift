//
//  SortMode.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/09/2021.
//

import UIKit

enum SortMode: Int, CaseIterable {
    case alphabetical
    case addedDate
    
    var name: String {
        switch self {
        case .alphabetical:
            return SwiftyAssets.Strings.messages_list_sort_by_alphabetical_order
        case .addedDate:
            return SwiftyAssets.Strings.messages_list_sort_by_date_added
        }
    }
    
    @available(iOS 14, *)
    var image: UIImage? {
        switch self {
        case .alphabetical:
            return UIImage(systemName: "abc")
        case .addedDate:
            return UIImage(systemName: "clock")
        }
    }
}
