//
//  BaseSettingsViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit
import SwiftyKit
import RxSwift
import RxDataSources
import TinyConstraints

enum SettingsType {
    case details(title: String? = nil, vc: UIViewController = UIViewController())
//    case speechRate
    
    var cellType: CellIdentifiable.Type {
        switch self {
        case .details:
            return DetailsTableViewCell.self
        }
    }
    
    var title: String {
        switch self {
        case .details(let title, let vc):
            return title ?? vc.title ?? ""
        }
    }
}

class BaseSettingsViewController: AbstractViewController {
    // MARK: - Typealias
    typealias Section = SectionModel<SectionHeaderFooter, SettingsType>
    
    // MARK: - IBOutlets
    private lazy var tableView: UITableView = {
        let tableView = TableView()
        
        let cells: [CellIdentifiable.Type] = [DetailsTableViewCell.self]
        cells.forEach {
            tableView.register($0.nib, forCellReuseIdentifier: $0.identifier)
        }
        
        tableView.contentInset = .vertical(20)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                tableView.deselectRow(at: indexPath, animated: true)
            }).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SettingsType.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                switch model {
                case .details(let title, let vc):
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }).disposed(by: disposeBag)
        
        return tableView
    }()
    
    // MARK: - Properties
    private var sections: [Section]
    
    // MARK: - Initialization
    init(title: String, sections: [Section]) {
        self.sections = sections
        super.init()
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func configure() {
        super.configure()
        configureTableView()
    }
    
    // MARK: - Configure
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.edgesToSuperview()
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: { _, tableView, indexPath, dataSource in
            let cellType = dataSource.cellType
            let cell = tableView.dequeueReusableCell(withIdentifier: cellType.identifier, for: indexPath)
            
            switch dataSource {
            case .details:
                if let cell = cell as? DetailsTableViewCell {
                    cell.configure(title: dataSource.title)
                }
            }
            
            return cell
        }, titleForHeaderInSection: { sections, indexPath -> String? in
            return sections.sectionModels[indexPath].model.header
        })
        
        Observable.just(sections)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension BaseSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: TableViewHeaderFooterView = .loadFromXib()
        view.configure(text: sections[safe: section]?.model.footer)
        return view
    }
}
