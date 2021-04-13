//
//  BaseListViewController.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit
import SwiftyKit
import RxSwift
import RxDataSources
import TinyConstraints

enum BaseListCellType {
    case details(title: String? = nil, vc: UIViewController = UIViewController())
    case link(title: String, urlString: String?)
    
//    case speechRate
    case editorAreaTextSize(SliderTableViewCell.State)
    case switchChoice(SwitchTableViewCell.State)
    
    var cellType: CellIdentifiable.Type {
        switch self {
        case .details:
            return DetailsTableViewCell.self
        case .link:
            return DetailsTableViewCell.self
        case .editorAreaTextSize:
            return SliderTableViewCell.self
        case .switchChoice:
            return SwitchTableViewCell.self
        }
    }
    
    var title: String {
        switch self {
        case .details(let title, let vc):
            return title ?? vc.title ?? ""
        case .link(let title, _):
            return title
        case .switchChoice(let state):
            return state.title
        case .editorAreaTextSize:
            return ""
        }
    }
}

class BaseListViewController: AbstractViewController {
    // MARK: - Typealias
    typealias Section = SectionModel<SectionHeaderFooter, BaseListCellType>
    
    // MARK: - IBOutlets
    private lazy var tableView: UITableView = {
        let tableView = TableView()
        
        let cells: [CellIdentifiable.Type] = [
            DetailsTableViewCell.self,
            SliderTableViewCell.self,
            SwitchTableViewCell.self
        ]
        
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
        
        tableView.rx.modelSelected(BaseListCellType.self)
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                switch model {
                case .details(let title, let vc):
                    self.navigationController?.pushViewController(vc, animated: true)
                case .link(title: let title, let urlString):
                    guard let urlString = urlString else { return }
                    self.openSafari(urlString: urlString)
                case .editorAreaTextSize,
                     .switchChoice:
                    break
                }
            }).disposed(by: disposeBag)
        
        return tableView
    }()
    
    // MARK: - Properties
    var sections = [Section]()
    
    // MARK: - Initialization
    init(title: String, sections: [Section]) {
        self.sections = sections
        super.init()
        self.title = title
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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
            case .details,
                 .link:
                if let cell = cell as? DetailsTableViewCell {
                    cell.configure(title: dataSource.title)
                }
            case .switchChoice(let state):
                if let cell = cell as? SwitchTableViewCell {
                    cell.configure(state: state)
                }
            case .editorAreaTextSize(let state):
                if let cell = cell as? SliderTableViewCell {
                    cell.configure(state: state)
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

extension BaseListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view: TableViewHeaderFooterView = .loadFromXib()
        view.configure(text: sections[safe: section]?.model.footer)
        return view
    }
}
