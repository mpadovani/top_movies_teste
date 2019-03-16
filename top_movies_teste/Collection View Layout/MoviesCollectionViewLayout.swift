//
//  MoviesCollectionViewLayout.swift
//  top_games
//
//  Created by Mateus Padovani on 09/03/19.
//  Copyright © 2019 Mateus Padovani. All rights reserved.
//

import UIKit

class MoviesCollectionViewLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        setupCollectionViewLayout(collectionView!)
    }
    
    func setupCollectionViewLayout(_ collectionView: UICollectionView) {
        scrollDirection = .vertical
        minimumLineSpacing = 8.0
        minimumInteritemSpacing = 0.0
        sectionInset = UIEdgeInsets(top: 8.0, left: 0.0, bottom: 8.0, right: 0.0)
        itemSize = self.itemSize(for: collectionView)
    }
    
    func itemSize(for collectionView: UICollectionView) -> CGSize {
        let safeWidth: CGFloat =  UIScreen.main.bounds.width - collectionView.safeAreaInsets.right - collectionView.safeAreaInsets.left
        let minItemWidth: CGFloat = 100.0
        
        let numberOfCell = safeWidth / minItemWidth
        let itemWidth = floor((numberOfCell / floor(numberOfCell)) * minItemWidth)
        let itemHeight = ceil(itemWidth * (4.0 / 3.0))

        return CGSize(width: itemWidth, height: itemHeight)
    }
}
