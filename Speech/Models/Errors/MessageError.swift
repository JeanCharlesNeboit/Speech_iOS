//
//  MessageError.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 17/09/2021.
//

import Foundation

enum MessageError: LocalizableError {
    case empty
    case duplication
    
    var title: String? {
        switch self {
        case .empty:
            return SwiftyAssets.Strings.editor_area_empty_text_on_save_title
        case .duplication:
            return SwiftyAssets.Strings.editor_area_duplication_title
        }
    }
    
    var body: String {
        switch self {
        case .empty:
            return SwiftyAssets.Strings.editor_area_empty_text_on_save_body
        case .duplication:
            return SwiftyAssets.Strings.editor_area_duplication_body
        }
    }
}
