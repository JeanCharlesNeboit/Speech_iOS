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

fileprivate enum SortMode: Int, CaseIterable {
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

class MessageListViewController: AbstractViewController {
    // MARK: - Typealias
    typealias Section = SectionModel<String, Message>
    
    // MARK: - IBOutlets
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyLabel: UILabel! {
        didSet {
            emptyLabel.text = SwiftyAssets.Strings.messages_list_empty
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let cells: [CellIdentifiable.Type] = [MessageTableViewCell.self]
            cells.forEach {
                tableView.register($0.nib, forCellReuseIdentifier: $0.identifier)
            }
            
            tableView.rx.modelSelected(Message.self)
                .subscribe(onNext: { message in
                    message.incrementNumberOfUse()
                    NotificationCenter.default.post(name: Notification.Name.editorAreaAppendText, object: message.text)
                }).disposed(by: disposeBag)
            
            tableView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Properties
    private var sectionsObservable = BehaviorSubject<[Section]>(value: [])
    private var sections: [Section] {
        (try? sectionsObservable.value()) ?? []
    }
    
    @SwiftyRawUserDefaults(key: "preferredMessagesSortMode", defaultValue: .alphabetical) private var preferredSortMode: SortMode
    private lazy var sortModeBehaviorSubject = BehaviorSubject<SortMode>(value: preferredSortMode)
    
    private lazy var moreBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(image: SwiftyAssets.Images.ellipsis_circle, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            SortMode.allCases.forEach { sortMode in
                let action = UIAlertAction(title: sortMode.name, style: .default, handler: { _ in
                    self.sortModeBehaviorSubject.onNext(sortMode)
                })
                alertController.addAction(action)
            }
            
            let popover = alertController.popoverPresentationController
            popover?.barButtonItem = button
            popover?.sourceRect = CGRect(x: 32, y: 32, width: 64, height: 64)
            
            self.present(alertController, animated: true)
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        // searchController.hidesNavigationBarDuringPresentation = false
        if !isCollapsed {
            searchController.searchBar.inputAccessoryView = EditorAreaToolbar.shared
        }
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    // MARK: - Configure
    override func configure() {
        title = SwiftyAssets.Strings.generic_messages
        definesPresentationContext = true
        
        sortModeBehaviorSubject.subscribe(onNext: { [self] sortMode in
            preferredSortMode = sortMode
        }).disposed(by: disposeBag)
        
        navigationItem()
        configureTableView()
    }
    
    private func navigationItem() {
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = moreBarButtonItem
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func configureTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: { _, tableView, indexPath, message in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(message: message)
            return cell
        }, titleForHeaderInSection: { sections, indexPath -> String? in
            return sections.sectionModels[indexPath].model
        }, canEditRowAtIndexPath: { _, _ in
            return true
        })
        
        let searchTextObservable = searchController.searchBar.rx.text.asObservable()
        let messagesResultsObservable = Observable.collection(from: realmService.getMessagesResult())
        Observable.combineLatest(searchTextObservable, messagesResultsObservable, sortModeBehaviorSubject)
            .map { search, messagesResult, orderMode -> [Message] in
                var messages = messagesResult.toArray()
                    .filter { message in
                        guard let search = search,
                              !search.trimmingCharacters(in: .whitespaces).isEmpty else { return true }
                        return message.text?.contains(search) ?? false
                    }
                
                switch orderMode {
                case .alphabetical:
                    messages = messages.sortedByAlphabeticalOrder()
                case .addedDate:
                    messages = messages.sortedByAddedDateOrder()
                }
                
                return messages
            }
            .map { messages -> [Section] in
                guard !messages.isEmpty else { return [] }
                return [
                    SectionModel(model: "Les plus utilisés*", items: messages),
                    SectionModel(model: "Toutes les messages*", items: messages)
                ]
            }
            .bind(to: sectionsObservable)
            .disposed(by: disposeBag)
        
        sectionsObservable
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.tableView.isHidden = $0.isEmpty
                self.emptyView.isHidden = !$0.isEmpty
            })
            .disposed(by: disposeBag)
            
        sectionsObservable
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension MessageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: SwiftyAssets.Strings.generic_delete) { [weak self] _, _, _ in
            guard let self = self else { return }
            guard let message = self.sections[safe: indexPath.section]?.items[safe: indexPath.row] else { return }
            self.realmService.deleteObject(message)
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
