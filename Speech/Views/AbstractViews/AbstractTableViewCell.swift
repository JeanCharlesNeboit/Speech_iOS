//
//  AbstractTableViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 30/03/2021.
//

import UIKit
import RxSwift
import SwiftyKit

class AbstractTableViewCell: UITableViewCell, CellIdentifiable {
    // MARK: - Properties
    let disposeBag = DisposeBag()
}
