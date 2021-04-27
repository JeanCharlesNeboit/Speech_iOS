//
//  MessageListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 27/03/2021.
//

import UIKit
import SwiftyKit
import RxSwift
import RxDataSources
import RealmSwift
import RxKeyboard

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

class MessageListViewController: BaseListViewController {
    // MARK: - Enums
    enum EmptyMode {
        case noData
        case noResult
        
        var title: String {
            switch self {
            case .noData:
                return SwiftyAssets.Strings.messages_list_empty_title
            case .noResult:
                return SwiftyAssets.Strings.messages_list_empty_search_title
            }
        }
        
        var body: String {
            switch self {
            case .noData:
                return SwiftyAssets.Strings.messages_list_empty_body
            case .noResult:
                return SwiftyAssets.Strings.messages_list_empty_search_body
            }
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyTitleLabel: UILabel!
    @IBOutlet weak var emptyBodyLabel: UILabel!
    
    // MARK: - Properties
    @RxBehaviorSubject private var sortMode = DefaultsStorage.preferredSortMode
    
    private lazy var moreBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(image: SwiftyAssets.UIImages.ellipsis_circle, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            SortMode.allCases.forEach { sortMode in
                let action = UIAlertAction(title: sortMode.name, style: .default, handler: { _ in
                    self.sortMode = sortMode
                })
                alertController.addAction(action)
            }
            
            let cancelAction = UIAlertAction(title: SwiftyAssets.Strings.generic_cancel, style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let popover = alertController.popoverPresentationController
            popover?.barButtonItem = button
            
            self.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var searchController: SearchController = {
        let searchController = SearchController(searchResultsController: nil)
        if !isCollapsed {
            searchController.searchBar.inputAccessoryView = EditorAreaToolbar.shared
        }
        return searchController
    }()
    
    // MARK: - Initialization
    override func sharedInit() {
        super.sharedInit()
        title = SwiftyAssets.Strings.generic_messages
        definesPresentationContext = true
    }
    
    // MARK: - Configure
    override func configure() {
        super.configure()
        
        $sortMode.subscribe(onNext: { sortMode in
            DefaultsStorage.preferredSortMode = sortMode
        }).disposed(by: disposeBag)
        
        navigationItem()
        configureTableView()
    }
    
    private func navigationItem() {
        if isCollapsed {
            navigationItem.leftBarButtonItem = cancelBarButtonItem
        }
        navigationItem.rightBarButtonItem = moreBarButtonItem
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func getSections(search: String?, messagesResult: Results<Message>, sortMode: SortMode, showFrequentlyUsedMessages: Bool) -> [Section] {
        var messages = messagesResult.toArray()
            .filter { message in
                guard let search = self.searchController.searchText else { return true }
                return message.text.contains(search)
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
            if showFrequentlyUsedMessages && self.searchController.searchText == nil {
                defaultSectionHeader = SwiftyAssets.Strings.messages_all
                let mostUsedMessages = self.realmService.mostUsedMessages(limit: 5)
                sections.append(SectionModel(model: .init(header: SwiftyAssets.Strings.messages_frequently_used),
                                             items: mostUsedMessages.map { .message($0) }))
            }
            sections.append(SectionModel(model: .init(header: defaultSectionHeader),
                                         items: messages.map { .message($0) }))
        }
        
        return sections
    }
    
    private func configureTableView() {
        tableView.rx.modelSelected(BaseListCellType.self)
            .subscribe(onNext: { cellType in
                guard case let .message(message) = cellType else { return }
                message.incrementNumberOfUse()
                NotificationCenter.default.post(name: Notification.Name.editorAreaAppendText, object: message.text)
            }).disposed(by: disposeBag)
        
        let searchTextObservable = searchController.searchBar.rx.text.asObservable()
        let messagesResultsObservable = Observable.collection(from: realmService.allMessagesResult())
        
        Observable.combineLatest(searchTextObservable,
                                 messagesResultsObservable,
                                 $sortMode,
                                 DefaultsStorage.$showFrequentlyUsedMessages)
            .subscribe(onNext: { [weak self] search, messagesResult, sortMode, showFrequentlyUsedMessages in
                guard let self = self else { return }
                self.sections = self.getSections(search: search, messagesResult: messagesResult, sortMode: sortMode, showFrequentlyUsedMessages: showFrequentlyUsedMessages)
            })
            .disposed(by: disposeBag)
        
        searchTextObservable
            .subscribe(onNext: { [weak self] search in
                guard let self = self else { return }
                if !search.strongValue.isEmpty {
                    self.configureEmptyView(mode: .noResult)
                } else {
                    self.configureEmptyView(mode: .noData)
                }
            }).disposed(by: disposeBag)
        
        $sections
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = $0.isEmpty
                self.emptyView.isHidden = !$0.isEmpty
            }).disposed(by: disposeBag)
        
        configureKeyboard()
    }
    
    private func configureKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [tableView] keyboardVisibleHeight in
                tableView.contentInset.bottom = keyboardVisibleHeight
                tableView.scrollIndicatorInsets.bottom = keyboardVisibleHeight
            }).disposed(by: disposeBag)
    }
    
    private func configureEmptyView(mode: EmptyMode) {
        emptyTitleLabel.text = mode.title
        emptyBodyLabel.text = mode.body
    }
}

extension MessageListViewController {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard case let .message(message) = self.sections[safe: indexPath.section]?.items[safe: indexPath.row] else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: SwiftyAssets.Strings.generic_delete) { [weak self] _, _, _ in
            guard let self = self else { return }
            self.realmService.deleteObject(message)
        }
//        deleteAction.image = SwiftyAssets.Images.gearshape
        
        let editAction = UIContextualAction(style: .normal, title: SwiftyAssets.Strings.generic_edit) { [weak self] _, _, success in
            guard let self = self else { return }
            self.present(NavigationController(rootViewController: MessageViewController(message: message)))
            success(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}
