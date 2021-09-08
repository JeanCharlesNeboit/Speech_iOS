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
    // MARK: - Typealias
    typealias MessageSection = SectionModel<SectionHeaderFooter, Message>
    typealias CategorySection = SectionModel<SectionHeaderFooter, Category>
    typealias GridSection = SectionModel<SectionHeaderFooter, [Category]>
    
    // MARK: - Properties
    @RxBehaviorSubject var search: String?
    @RxBehaviorSubject var sortMode = DefaultsStorage.preferredMessageSortMode
    
    @RxBehaviorSubject var messageSections = [MessageSection]()
    @RxBehaviorSubject var categorySections = [CategorySection]()
    
    // MARK: - Initialization
    override init() {
        super.init()
        observeSortMode()
        observeMessageResult()
    }
    
    // MARK: - Observation
    private func observeMessageResult() {
        let messagesResultsObservable = Observable.collection(from: realmService.allMessagesResult())
        let categoriesResultObservable = Observable.collection(from: realmService.getCategoriesResult(parentCategory: nil))
        
        Observable.combineLatest($search,
                                 messagesResultsObservable,
                                 categoriesResultObservable,
                                 $sortMode,
                                 DefaultsStorage.$showFrequentlyUsedMessages)
            .subscribe(onNext: { [weak self] search, messagesResult, categoriesResult, sortMode, showFrequentlyUsedMessages in
                guard let self = self else { return }
                self.messageSections = self.getMessageSections(search: search, messagesResult: messagesResult, sortMode: sortMode, showFrequentlyUsedMessages: showFrequentlyUsedMessages)
                
                self.categorySections = self.getCategorySections(search: search, categoriesResult: categoriesResult, sortMode: sortMode, showFrequentlyUsedMessages: showFrequentlyUsedMessages)
                
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
            if showFrequentlyUsedMessages && search.isEmptyOrNil {
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
    
    private func getCategorySections(search: String?, categoriesResult: Results<Category>, sortMode: SortMode, showFrequentlyUsedMessages: Bool) -> [CategorySection] {
        var categories = categoriesResult.toArray()
        categories.append(WithoutCategory())
        let filteredCategories = categories.filter(search: search)
        
        #warning("sortMode")
        
        var sections = [CategorySection]()
        if !filteredCategories.isEmpty {
            var defaultSectionHeader: String?
            if showFrequentlyUsedMessages && search.isEmptyOrNil {
                defaultSectionHeader = SwiftyAssets.Strings.generic_categories
                #warning("Factorize limit & rename messages_frequently_used")
                let mostUsedCategories = self.realmService.mostUsedCategories(limit: 5)
                sections.append(SectionModel(model: .init(header: SwiftyAssets.Strings.messages_frequently_used),
                                             items: mostUsedCategories))
            }
            sections.append(SectionModel(model: .init(header: defaultSectionHeader),
                                         items: filteredCategories.map { $0 }))
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
