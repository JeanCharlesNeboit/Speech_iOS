//
//  TableView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit
import SwiftyKit

class TableView: AbstractTableView {
    // MARK: - Properties
    private static var Style: UITableView.Style {
        guard #available(iOS 13, *) else {
            return .grouped
        }
        return .insetGrouped
    }

    // MARK: - Initialization
    init() {
        super.init(frame: .zero, style: Self.Style)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    override func sharedInit() {
        super.sharedInit()
        registerCells()
        sectionHeaderHeight = UITableView.automaticDimension
        estimatedSectionHeaderHeight = 20
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 100
        sectionFooterHeight = UITableView.automaticDimension
        estimatedSectionFooterHeight = 20
    }
    
    // MARK: -
    private func registerCells() {
        let cells: [CellIdentifiable.Type] = [
            ContainerTableViewCell.self,
            DetailsTableViewCell.self,
            SliderTableViewCell.self,
            SwitchTableViewCell.self,
            MessageTableViewCell.self,
            CategoryTableViewCell.self
        ]
        
        cells.forEach {
            register($0.nib, forCellReuseIdentifier: $0.identifier)
        }
    }
}
