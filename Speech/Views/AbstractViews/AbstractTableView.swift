//
//  AbstractTableView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 12/05/2021.
//

import UIKit

class AbstractTableView: UITableView {
    // MARK: - Properties
//    let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    func sharedInit() {
        
    }
}
