//
//  SettingsViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 29/03/2021.
//

import UIKit
import RxSwift
import RxDataSources
import SwiftMessages

protocol PresentedInSwiftMessagesSegue where Self: UIViewController {
    var segue: SwiftMessagesSegue? { get set }
}

class SettingsViewController: AbstractViewController, PresentedInSwiftMessagesSegue {
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var segue: SwiftMessagesSegue?
    private var widthConstraint: NSLayoutConstraint?
    
//    public override var preferredContentSize: CGSize {
//        get {
//            let screenBounds = UIScreen.main.bounds
//            return CGSize(width: screenBounds.width * 0.5, height: screenBounds.height * 0.6)
//        }
//
//        set { super.preferredContentSize = newValue }
//    }
    
    private lazy var validBarButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: SwiftyAssets.Strings.generic_validate, style: .done, target: nil, action: nil)
        button.rx.tap.subscribe(onNext: {
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        return button
    }()
    
    // MARK: - Lifecycle
    override func configure() {
        title = SwiftyAssets.Strings.generic_settings
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = validBarButtonItem
        configureTableView()
    }
    
    // MARK: - Configure
    private func configureTableView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<SectionHeaderFooter, String>>(configureCell: { _, tableView, indexPath, message in
            //guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.identifier, for: indexPath) as? MessageTableViewCell else {
                return UITableViewCell()
            //}
            //cell.configure(message: message)
            //return cell
        }, titleForHeaderInSection: { sections, indexPath -> String? in
            return sections.sectionModels[indexPath].model.header
        }, canEditRowAtIndexPath: { _, _ in
            return true
        })
        
        Observable.just([
                SectionModel(model: SectionHeaderFooter(header: "Hello*"), items: [""])
            ])
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}
