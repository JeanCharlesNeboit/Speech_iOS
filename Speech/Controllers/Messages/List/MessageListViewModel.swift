//
//  MessageListViewModel.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 25/05/2021.
//

import Foundation
import RxSwift
import RxDataSources
import RealmSwift

class MessageListViewModel: AbstractViewModel {
    // MARK: - Enum
    enum DataSource {
        case message(Message)
        case categories([Category])
    }
    
    // MARK: - Typealias
    typealias Section = SectionModel<SectionHeaderFooter, DataSource>
    
    // MARK: - Properties
    let category: Category?
    let gridColumn = 2
    private let mostUsedLimit = 5
    
    @RxBehaviorSubject var search: String?
    @RxBehaviorSubject var sortMode = DefaultsStorage.preferredMessageSortMode
    
    @RxBehaviorSubject var sections = [Section]()
    
    // MARK: - Initialization
    init(category: Category?) {
        self.category = category
        super.init()
        observeSortMode()
        observeMessageResult()
    }
    
    // MARK: - Observation
    private func observeMessageResult() {
        let messagesResultsObservable = Observable.collection(from: realmService.getMessagesResult(in: category))
        let categoriesResultObservable = Observable.collection(from: realmService.getCategories(parent: category))
        
        Observable.combineLatest($search,
                                 messagesResultsObservable,
                                 categoriesResultObservable,
                                 $sortMode,
                                 DefaultsStorage.$showFrequentlyUsedMessages,
                                 DefaultsStorage.$preferredMessageDisplayMode)
            .subscribe(onNext: { [weak self] search, messagesResult, categoriesResult, sortMode, showFrequentlyUsed, displayMode in
                guard let self = self else { return }
                switch displayMode {
                case .list:
                    self.sections = self.getListSections(search: search, messagesResult: messagesResult, sortMode: sortMode, showFrequentlyUsed: showFrequentlyUsed)
                case .grid:
                    self.sections = self.getGridSections(search: search, messagesResult: messagesResult, categoriesResult: categoriesResult, sortMode: sortMode, showFrequentlyUsed: showFrequentlyUsed)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func observeSortMode() {
        $sortMode.subscribe(onNext: { sortMode in
            DefaultsStorage.preferredMessageSortMode = sortMode
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Sections
    private func getListSections(search: String?, messagesResult: Results<Message>, sortMode: SortMode, showFrequentlyUsed: Bool) -> [Section] {
        var messages = messagesResult.toArray().filter(search: search)
        
        switch sortMode {
        case .alphabetical:
            messages = messages.sortedByAlphabeticalOrder()
        case .addedDate:
            messages = messages.sortedByAddedDateOrder()
        }
        
        var sections = [Section]()
        if !messages.isEmpty {
            var defaultSectionHeader: String?
            if showFrequentlyUsed && search.isEmptyOrNil && category == nil {
                defaultSectionHeader = SwiftyAssets.Strings.messages_all
                let mostUsedMessages = self.realmService.mostUsedMessages(limit: mostUsedLimit)
                sections.append(SectionModel(model: .init(header: SwiftyAssets.Strings.messages_frequently_used),
                                             items: mostUsedMessages.map { .message($0) }))
            }
            sections.append(SectionModel(model: .init(header: defaultSectionHeader),
                                         items: messages.map { .message($0) }))
        }
        return sections
    }
    
    private func getGridSections(search: String?, messagesResult: Results<Message>, categoriesResult: Results<Category>, sortMode: SortMode, showFrequentlyUsed: Bool) -> [Section] {
        let messages = messagesResult.toArray().filter(search: search)
        
        var categories = categoriesResult.toArray()
        let withoutCategory = Category.withoutCategory
        if category == nil && !withoutCategory.messages.isEmpty {
            categories.append(withoutCategory)
        }
        let filteredCategories = categories.filter(search: search)
        
        #warning("sortMode")
        
        var sections = [Section]()
        if !filteredCategories.isEmpty || !messages.isEmpty {
            var defaultSectionHeader: String? = SwiftyAssets.Strings.generic_categories
            if showFrequentlyUsed && search.isEmptyOrNil && category == nil {
                let mostUsedCategories = self.realmService.mostUsedCategories(limit: mostUsedLimit)
                sections.append(SectionModel(model: .init(header: SwiftyAssets.Strings.messages_frequently_used),
                                             items: mostUsedCategories.chunked(into: self.gridColumn).map { .categories($0 )}))
            } else if category != nil {
                sections.append(SectionModel(model: .init(header: SwiftyAssets.Strings.generic_messages),
                                             items: messages.map { .message($0) }))
            }
            
            if sections.isEmpty {
                defaultSectionHeader = nil
            }
            sections.append(SectionModel(model: .init(header: defaultSectionHeader),
                                         items: filteredCategories.chunked(into: self.gridColumn).map { .categories($0) }))
        }
        return sections
    }
    
    // MARK: -
    func onDelete(message: Message) {
        realmService.deleteObject(message)
    }
    
    func onTap(message: Message) {
        NotificationCenter.default.post(name: .EditorAreaAppendText, object: message)
    }
}
