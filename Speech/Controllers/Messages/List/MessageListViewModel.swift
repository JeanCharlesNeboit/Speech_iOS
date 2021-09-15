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
    typealias MessageSection = SectionModel<SectionHeaderFooter, Message>
    typealias CategorySection = SectionModel<SectionHeaderFooter, DataSource>
    
    // MARK: - Properties
    let category: Category?
    let gridColumn = 2
    
    @RxBehaviorSubject var search: String?
    @RxBehaviorSubject var sortMode = DefaultsStorage.preferredMessageSortMode
    
    @RxBehaviorSubject var messageSections = [MessageSection]()
    @RxBehaviorSubject var categorySections = [CategorySection]()
    
    // MARK: - Initialization
    init(category: Category?) {
        self.category = category
        super.init()
        observeSortMode()
        observeMessageResult()
    }
    
    // MARK: - Observation
    private func observeMessageResult() {
        let messagesResultsObservable = Observable.collection(from: category == nil ? realmService.allMessagesResult() : realmService.allMessagesResult(category: category))
        let categoriesResultObservable = Observable.collection(from: realmService.getCategoriesResult(parentCategory: category))
        
        Observable.combineLatest($search,
                                 messagesResultsObservable,
                                 categoriesResultObservable,
                                 $sortMode,
                                 DefaultsStorage.$showFrequentlyUsedMessages)
            .subscribe(onNext: { [weak self] search, messagesResult, categoriesResult, sortMode, showFrequentlyUsedMessages in
                guard let self = self else { return }
                self.messageSections = self.getMessageSections(search: search, messagesResult: messagesResult, sortMode: sortMode, showFrequentlyUsedMessages: showFrequentlyUsedMessages)
                
                self.categorySections = self.getCategorySections(search: search, messagesResult: messagesResult, categoriesResult: categoriesResult, sortMode: sortMode, showFrequentlyUsedMessages: showFrequentlyUsedMessages)
                
            })
            .disposed(by: disposeBag)
    }
    
    private func observeSortMode() {
        $sortMode.subscribe(onNext: { sortMode in
            DefaultsStorage.preferredMessageSortMode = sortMode
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Sections
    private func getMessageSections(search: String?, messagesResult: Results<Message>, sortMode: SortMode, showFrequentlyUsedMessages: Bool) -> [MessageSection] {
        var messages = messagesResult.toArray().filter(search: search)
        
        switch sortMode {
        case .alphabetical:
            messages = messages.sortedByAlphabeticalOrder()
        case .addedDate:
            messages = messages.sortedByAddedDateOrder()
        }
        
        var sections = [MessageSection]()
        if !messages.isEmpty {
            var defaultSectionHeader: String?
            if showFrequentlyUsedMessages && search.isEmptyOrNil && category == nil {
                defaultSectionHeader = SwiftyAssets.Strings.messages_all
                let mostUsedMessages = self.realmService.mostUsedMessages(limit: 5)
                sections.append(SectionModel(model: .init(header: SwiftyAssets.Strings.messages_frequently_used),
                                             items: mostUsedMessages))
            }
            sections.append(SectionModel(model: .init(header: defaultSectionHeader),
                                         items: messages))
        }
        return sections
    }
    
    private func getCategorySections(search: String?, messagesResult: Results<Message>, categoriesResult: Results<Category>, sortMode: SortMode, showFrequentlyUsedMessages: Bool) -> [CategorySection] {
        let messages = messagesResult.toArray().filter(search: search)
        var categories = categoriesResult.toArray()
        if category == nil {
            categories.append(Category.withoutCategory)
        }
        let filteredCategories = categories.filter(search: search)
        
        #warning("sortMode")
        
        var sections = [CategorySection]()
        if !filteredCategories.isEmpty || !messages.isEmpty {
            var defaultSectionHeader: String?
            if showFrequentlyUsedMessages && search.isEmptyOrNil && category == nil {
                defaultSectionHeader = SwiftyAssets.Strings.generic_categories
                #warning("Factorize limit & rename messages_frequently_used")
                let mostUsedCategories = self.realmService.mostUsedCategories(limit: 5)
                sections.append(SectionModel(model: .init(header: SwiftyAssets.Strings.messages_frequently_used),
                                             items: mostUsedCategories.chunked(into: self.gridColumn).map { .categories($0 )}))
            } else if category != nil {
                sections.append(SectionModel(model: .init(header: SwiftyAssets.Strings.generic_messages),
                                             items: messages.map { .message($0) }))
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
        NotificationCenter.default.post(name: Notification.Name.editorAreaAppendText, object: message)
    }
}
