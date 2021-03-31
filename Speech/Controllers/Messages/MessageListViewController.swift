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
        }
    }
    
    // MARK: - Properties
    private lazy var moreBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(image: SwiftyAssets.Images.ellipsis_circle, style: .plain, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController()
        searchController.searchBar.searchBarStyle = .minimal
        // searchController.hidesNavigationBarDuringPresentation = false
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
            cell.textLabel?.text = message.text
            return cell
        })
        
        Observable.collection(from: realmService.getMessagesResult())
            .map {
                [SectionModel(model: "", items: $0.toArray())]
            }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Message.self)
            .subscribe(onNext: { message in
                NotificationCenter.default.post(name: Notification.Name.editorAreaAppendText, object: message.text)
            }).disposed(by: disposeBag)
    }
}
