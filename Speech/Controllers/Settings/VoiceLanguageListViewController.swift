//
//  VoiceLanguageListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/09/2021.
//

import UIKit
import AVFoundation
import RxSwift

extension Locale: Searchable {
    var searchText: String {
        [
            localizedStringWithFlag,
            currentLocaleLocalizedString
        ].compactMap { $0 }
        .joined(separator: " ")
    }
}

 extension Locale {
    var localizedStringWithFlag: String {
        [
            countryFlag,
            localizedString(forIdentifier: identifier)?.capitalizingFirstLetter()
        ].compactMap { $0 }
        .joined(separator: " ")
    }
    
    var currentLocaleLocalizedString: String? {
        Locale.current.localizedString(forIdentifier: identifier)?.capitalizingFirstLetter()
    }
 }

class VoiceLanguageListViewController: BaseListViewController {
    // MARK: - Properties
    private var languages: [Locale] {
        Dictionary(grouping: AVSpeechSynthesisVoice.speechVoices(), by: { Locale(identifier: $0.language) })
            .map { $0.key }
            .sorted { lhs, rhs in
                lhs.localizedString(forIdentifier: lhs.identifier).strongValue < rhs.localizedString(forIdentifier: rhs.identifier).strongValue
            }
    }
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.preferences_preferred_voice_language
    }
    
    // MARK: - Configure
    override func configure() {
        super.configure()
        configureNavigationItem()
        configureKeyboard()
        
        Observable.combineLatest(searchController.searchBar.rx.text.asObservable(), DefaultsStorage.$preferredLanguage)
            .subscribe(onNext: { [weak self] search, preferredLanguage in
                self?.update(search: search, preferredLanguage: preferredLanguage)
            }).disposed(by: disposeBag)
    }
    
    private func update(search: String?, preferredLanguage: String?) {
        let cell: ((Locale) -> BaseListCellType) = { locale in
            let isSelected = locale.identifier == preferredLanguage
            return .selection(config: .init(title: locale.localizedStringWithFlag,
                                            subtitle: locale.currentLocaleLocalizedString),
                              isSelected: isSelected,
                              onTap: {
                DefaultsStorage.preferredLanguage = locale.identifier
            })
        }
        
        if let search = search.nilIfEmpty {
            sections = [
                Section(model: .init(header: ""),
                        items: languages
                            .filter(search: search)
                            .map { cell($0) })
            ]
        } else {
            sections = [
                Section(model: .init(header: ""),
                        items: languages.filter { $0.identifier != preferredLanguage }.map { cell($0) })
            ]
            
            if let preferredLocale = languages.first(where: { $0.identifier == preferredLanguage }) {
                sections.insert(Section(model: .init(header: ""), items: [preferredLocale].map { cell($0) }), at: 0)
            }
        }
        
    }

    private func configureNavigationItem() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// NSLinguisticTagger.dominantLanguage(for: text)
// https://developer.apple.com/documentation/naturallanguage/identifying_the_language_in_text
