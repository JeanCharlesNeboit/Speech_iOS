//
//  AbstractCollectionViewCell.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 25/05/2021.
//

import UIKit
import SwiftyKit
import RxSwift

class AbstractCollectionViewCell: UICollectionViewCell, CellIdentifiable {
    // MARK: - Properties
    let disposeBag = DisposeBag()
}
