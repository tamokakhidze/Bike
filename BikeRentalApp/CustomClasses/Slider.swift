//
//  Slider.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 07.07.24.
//

import UIKit

class Slider: UICollectionView {
    
    init(scrollDirection: UICollectionView.ScrollDirection = .horizontal,
         lineSpacing: CGFloat = 0,
         interItemSpacing: CGFloat = 0,
         itemWidth: CGFloat = 400,
         itemHeight: CGFloat = 200,
         cell: AnyClass?,
         identifier: String,
         paging: Bool = false,
         showIndicator: Bool = false,
         tag: Int) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.minimumLineSpacing = lineSpacing
        layout.minimumInteritemSpacing = interItemSpacing
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight )
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.register(cell, forCellWithReuseIdentifier: identifier)
        self.showsHorizontalScrollIndicator = showIndicator
        self.isPagingEnabled = paging
        self.frame = .zero
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.tag = tag
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
