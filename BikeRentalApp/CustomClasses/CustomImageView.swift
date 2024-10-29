//
//  CustomImageView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import UIKit

class CustomImageView: UIImageView {
    
    init(width: CGFloat, height: CGFloat, backgroundImage: String, borderColor: UIColor = .clear, borderWidth: CGFloat = 0) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.image = UIImage(named: backgroundImage)
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = height / 2
        self.tintColor = .lightGray
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

