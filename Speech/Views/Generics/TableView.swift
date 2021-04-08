//
//  TableView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 06/04/2021.
//

import UIKit

class TableView: UITableView {
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
        super.init(frame: .zero, style: Self.Style)
        sharedInit()
    }
    
    private func sharedInit() {
        
    }
}
