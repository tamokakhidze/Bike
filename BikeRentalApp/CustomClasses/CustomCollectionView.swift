//
//  CustomCollectionView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import UIKit
//კლასად გადავაკეთო მოგვიანებით.
func configureCollectionView(itemWidth: CGFloat, itemHeight: CGFloat, lineSpacing: CGFloat, itemSpacing: CGFloat, scrollDirection: UICollectionView.ScrollDirection) -> UICollectionView {
    var collectionView: UICollectionView?
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = scrollDirection
    layout.minimumLineSpacing = lineSpacing
    layout.minimumInteritemSpacing = itemSpacing
    
    let itemWidth = itemWidth
    let itemHeight = itemHeight
    layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    guard let collectionView = collectionView else { return UICollectionView() }
    
    collectionView.register(BikeCollectionViewCell.self, forCellWithReuseIdentifier: BikeCollectionViewCell.identifier)
    
    collectionView.backgroundColor = .clear
    
    return collectionView
}
