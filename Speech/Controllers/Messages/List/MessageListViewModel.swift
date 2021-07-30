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
}

class MessageListViewModel: AbstractViewModel {
    // MARK: - Typealias
    typealias Section = SectionModel<SectionHeaderFooter, Message>
    typealias GridSection = SectionModel<SectionHeaderFooter, [Message]>
    
    // MARK: - Properties
    @RxBehaviorSubject var sections = [Section]()
    @RxBehaviorSubject var search: String?
    @RxBehaviorSubject var sortMode = DefaultsStorage.preferredSortMode
    
    // MARK: - Initialization
    override init() {
        super.init()
        observeSortMode()
        observeMessageResult()
    }
    
    // MARK: - Observation
    private func observeMessageResult() {
        let messagesResultsObservable = Observable.collection(from: realmService.allMessagesResult())
        
        Observable.combineLatest($search,
                                 messagesResultsObservable,
                                 $sortMode,
                                 DefaultsStorage.$showFrequentlyUsedMessages)
            .subscribe(onNext: { [weak self] search, messagesResult, sortMode, showFrequentlyUsedMessages in
                guard let self = self else { return }
                self.sections = self.getSections(search: search, messagesResult: messagesResult, sortMode: sortMode, showFrequentlyUsedMessages: showFrequentlyUsedMessages)
            })
            .disposed(by: disposeBag)
    }
    
    private func observeSortMode() {
        $sortMode.subscribe(onNext: { sortMode in
            DefaultsStorage.preferredSortMode = sortMode
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Sections
    private func getSections(search: String?, messagesResult: Results<Message>, sortMode: SortMode, showFrequentlyUsedMessages: Bool) -> [Section] {
        var messages = messagesResult.toArray()
            .filter { message in
                guard !search.isEmptyOrNil,
                      let search = search else { return true }
                return message.text.uppercased().contains(search.uppercased())
            }
        
        switch sortMode {
        case .alphabetical:
            messages = messages.sortedByAlphabeticalOrder()
        case .addedDate:
            messages = messages.sortedByAddedDateOrder()
        }
        
        var sections = [Section]()
        if !messages.isEmpty {
            var defaultSectionHeader: String?
            if showFrequentlyUsedMessages && search.isEmptyOrNil {
                defaultSectionHeader = SwiftyAssets.Strings.messages_all
                let mostUsedMessages = self.realmService.mostUsedMessages(limit: 5)
                sections.append(SectionModel(model: .init(header: SwiftyAssets.Strings.messages_frequently_used),
                                             items: mostUsedMessages.map { $0 }))
            }
            sections.append(SectionModel(model: .init(header: defaultSectionHeader),
                                         items: messages.map { $0 }))
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
