//
//  InputError.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 17/09/2021.
//

import Foundation

enum InputError: LocalizableError {
    enum InputType {
        case message
        case category
    }
    
    case empty
    case duplication(type: InputType)
    
    var title: String? {
        switch self {
        case .empty:
            return SwiftyAssets.Strings.editor_area_empty_text_on_save_title
        case .duplication:
            return SwiftyAssets.Strings.error_duplication_title
        }
    }
    
    var body: String {
        switch self {
        case .empty:
            return SwiftyAssets.Strings.editor_area_empty_text_on_save_body
        case .duplication(let type):
            switch type {
            case .message:
                return SwiftyAssets.Strings.error_duplication_message_body
            case .category:
                return SwiftyAssets.Strings.error_duplication_category_body
            }
        }
    }
}
