//
//  SmallCustomButton.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 04.07.24.
//

import UIKit

class SmallCustomButton: UIButton {
    
    init(width: CGFloat, height: CGFloat, backgroundImage: String = "", backgroundColor: UIColor) {
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = height / 2
        self.clipsToBounds = true
        
        if !backgroundImage.isEmpty {
            let imageView = UIImageView(image: UIImage(named: backgroundImage)?.withRenderingMode(.alwaysTemplate))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.tintColor = .lightGray
            imageView.layer.cornerRadius = 5
            imageView.clipsToBounds = true
            self.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 20),
                imageView.heightAnchor.constraint(equalToConstant: 20)
            ])
        }
        
        self.layer.shadowColor = UIColor.gray.withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 22.9)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 11.45
        self.layer.masksToBounds = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let margin: CGFloat = 10
        let area = self.bounds.insetBy(dx: -margin, dy: -margin)
        return area.contains(point)
    }
}
