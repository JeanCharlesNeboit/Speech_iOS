//
//  AbstractCollectionView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 12/05/2021.
//

import UIKit

class AbstractCollectionView: UICollectionView {
    // MARK: - Properties
//    let disposeBag = DisposeBag()
    
    // MARK: - Initialization
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }
    
    func sharedInit() {
        
    }
}
