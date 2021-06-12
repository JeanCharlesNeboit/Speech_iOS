//
//  GridCollectionViewLayout.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 02/06/2021.
//

import UIKit

protocol UICollectionViewLayoutSizeable {
    func sizeForItem(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize
}

class GridCollectionViewLayout: UICollectionViewFlowLayout, UICollectionViewLayoutSizeable {
    // MARK: - Properties
    private(set) var column: Int = 2
    
    // MARK: - Initialization
    init(column: Int) {
        self.column = column
        super.init()
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init()
        sharedInit()
    }
    
    private func sharedInit() {
        minimumInteritemSpacing = 20
        minimumLineSpacing = 20
        sectionInset = .init(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    // MARK: - Layout
    func sizeForItem(indexPath: IndexPath, collectionView: UICollectionView) -> CGSize {
        let width = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        let cellSpacing = minimumInteritemSpacing
        let columnFloat = CGFloat(column)
        let cellWidth = ((width - (columnFloat - 1) * cellSpacing)/columnFloat).rounded(.down)
        let cellHeight = cellWidth
        
        return .init(width: cellWidth, height: cellHeight)
    }
}
