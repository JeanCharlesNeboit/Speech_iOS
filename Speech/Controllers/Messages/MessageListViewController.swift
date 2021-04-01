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

class MessageListViewController: AbstractViewController {
    // MARK: - IBOutlets
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
    private lazy var moreBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(image: SwiftyAssets.Images.ellipsis_circle, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.searchBarStyle = .minimal
        // searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.inputAccessoryView = EditorAreaToolbar.shared
        searchController.dimsBackgroundDuringPresentation = false
        return searchController
    }()
    
    // MARK: - Configure
    override func configure() {
        title = SwiftyAssets.Strings.generic_messages
        navigationItem.rightBarButtonItem = moreBarButtonItem
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        configureTableView()
    }
    
    private func configureTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Message>>(configureCell: { _, tableView, indexPath, message in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(message: message)
            return cell
        }, canEditRowAtIndexPath: { _, _ in
            return true
        })
        
        let searchTextObservable = searchController.searchBar.rx.text.asObservable()
        let messagesResultsObservable = Observable.collection(from: realmService.getMessagesResult())
        Observable.combineLatest(searchTextObservable, messagesResultsObservable)
            .map { search, messagesResult in
                var messages = messagesResult.toArray()
                    .filter { message in
                        guard let search = search,
                              !search.trimmingCharacters(in: .whitespaces).isEmpty else { return true }
                        return message.text?.contains(search) ?? false
                    }
                messages = messages.sorted(by: { lhs, rhs -> Bool in
                    lhs.text.strongValue.folding(options: .diacriticInsensitive, locale: .current) < rhs.text.strongValue.folding(options: .diacriticInsensitive, locale: .current)
                })
                return messages
            }
            .map {
                [SectionModel(model: "", items: $0)]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension MessageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: SwiftyAssets.Strings.generic_delete) { _, _, _ in
            
        }
        let configuration = UISwipeActionsConfiguration(actions: [action])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}
