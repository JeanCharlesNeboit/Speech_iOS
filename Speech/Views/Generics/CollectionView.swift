//
//  CollectionView.swift
//  Speech
//
//  Created by Jean-Charles Neboit on 25/05/2021.
//

import UIKit
import SwiftyKit

class CollectionView: AbstractCollectionView {
    // MARK: - Properties
    static var collectionLayout: UICollectionViewFlowLayout {
        let collectionLayout = GridCollectionViewLayout(column: 2)
        collectionLayout.headerReferenceSize = .init(width: 0, height: 1)
        return collectionLayout
    }
    
    // MARK: - Initialization
    init() {
        super.init(frame: .zero, collectionViewLayout: Self.collectionLayout)
        sharedInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit()
    }

    override func sharedInit() {
        super.sharedInit()
        delegate = self
        registerCells()
    }
    
    // MARK: -
    private func registerCells() {        
        let cells: [CellIdentifiable.Type] = [
//            MessageCollectionViewCell.self
        ]
        
        cells.forEach {
            register($0.nib, forCellWithReuseIdentifier: $0.identifier)
        }
    }
}

extension CollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewLayoutSizeable else {
            return .zero
        }
        return layout.sizeForItem(indexPath: indexPath, collectionView: collectionView)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        guard let view = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: section)) else {
//            return .zero
//        }
//        return view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
//    }
}
