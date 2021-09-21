//
//  SpeechError.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 21/09/2021.
//

import Foundation

protocol LocalizableError: Error {
    var title: String? { get }
    var body: String { get }
}

struct CustomLocalizableError: LocalizableError {
    var title: String?
    var body: String
}

enum SpeechError: LocalizableError {
    case localized(LocalizableError)
    
    var title: String? {
        switch self {
        case .localized(let error):
            return error.title ?? "Une erreur est survenue*"
        }
    }
    
    var body: String {
        switch self {
        case .localized(let error):
            return error.body
        }
    }
}

extension Error {
    var toLocalizableError: LocalizableError {
        CustomLocalizableError(title: nil, body: localizedDescription)
    }
}
