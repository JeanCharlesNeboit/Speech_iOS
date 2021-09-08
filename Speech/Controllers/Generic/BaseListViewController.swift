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
    case container(view: UIView, onConfigure: ((IndexPath) -> Void)?)
    case details(title: String, withViewController: (() -> UIViewController?))
    case action(title: String, onTap: (() -> Void)?)
    case link(Link)
    case slider(SliderTableViewCell.Config)
    case switchChoice(SwitchTableViewCell.Config)
    case category(Category?)
    
    var cellType: CellIdentifiable.Type {
        switch self {
        case .container:
            return ContainerTableViewCell.self
        case .details,
             .action,
            .link:
            return DetailsTableViewCell.self
        case .slider:
            return SliderTableViewCell.self
        case .switchChoice:
            return SwitchTableViewCell.self
        case .category:
            return CategoryTableViewCell.self
        }
    }
    
    func configure(cell: UITableViewCell, indexPath: IndexPath) {
        switch self {
        case .container(let view, let onConfigure):
            (cell as? ContainerTableViewCell)?.configure(view: view)
            onConfigure?(indexPath)
        case .details(let title, _):
            (cell as? DetailsTableViewCell)?.configure(title: title, accessoryType: .disclosureIndicator)
        case .action(let title, _):
            (cell as? DetailsTableViewCell)?.configure(title: title)
        case .link(let link):
            (cell as? DetailsTableViewCell)?.configure(title: link.title)
        case .switchChoice(let state):
            (cell as? SwitchTableViewCell)?.configure(config: state)
        case .slider(let state):
            (cell as? SliderTableViewCell)?.configure(config: state)
        case .category(let category):
            (cell as? CategoryTableViewCell)?.configure(category: category)
        }
    }
}

class BaseListViewController: AbstractViewController {
    // MARK: - Typealias
    typealias Section = SectionModel<SectionHeaderFooter, BaseListCellType>
    
    // MARK: - IBOutlets
    lazy var tableView: TableView = {
        let tableView = TableView()
                
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
                case .details(let title, let closure):
                    guard let vc = closure() else { return }
                    self.navigationController?.pushViewController(vc, animated: true)
                case .action(_, let onTap):
                    onTap?()
                case .link(let link):
                    self.openSafari(urlString: link.urlString)
                case .container,
                     .slider,
                     .switchChoice,
                     .category:
                    break
                }
            }).disposed(by: disposeBag)
        
        return tableView
    }()
    
    // MARK: - Properties
    @RxBehaviorSubject var sections = [Section]()
    
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
    
    override func sharedInit() {
        super.sharedInit()
    }
    
    // MARK: - Lifecycle
    override func configure() {
        super.configure()
        configureTableView()
    }
    
    // MARK: - Configure
    private func configureTableView() {
        view.insertSubview(tableView, at: 0)
        tableView.edgesToSuperview()
        
        if self is FormViewController {
            tableView.keyboardDismissMode = .interactive
        }
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section>(configureCell: { _, tableView, indexPath, dataSource in
            let cell = tableView.dequeueReusableCell(withIdentifier: dataSource.cellType.identifier, for: indexPath)
            dataSource.configure(cell: cell, indexPath: indexPath)
            return cell
        }, titleForHeaderInSection: { sections, indexPath -> String? in
            return sections.sectionModels[indexPath].model.header
        })
        
        $sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension BaseListViewController: UITableViewDelegate {    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        guard let header = sections[safe: section]?.model.header else { return nil }
//        let view: TableViewHeaderFooterView = .loadFromXib()
//        view.configure(text: header)
//        return view
//    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = sections[safe: section]?.model.footer else { return nil }
        let view: TableViewHeaderFooterView = .loadFromXib()
        view.configure(text: footer, textAlignment: .center)
        return view
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       return nil
    }
}
