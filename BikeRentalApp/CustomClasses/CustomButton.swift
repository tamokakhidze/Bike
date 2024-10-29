//
//  CustomButton.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

class CustomButton: UIButton {
    
    init(title: String, hasBackground: Bool = false, width: CGFloat) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = hasBackground ? .black: .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: hasBackground ? 50 : 25).isActive = true
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.layer.cornerRadius = 25
        self.titleLabel?.font = .systemFont(ofSize: hasBackground ? 14 : 12, weight: .bold)
        self.setTitleColor(hasBackground ? .white : .systemBlue, for: .normal)
        self.setTitleColor(.systemGray, for: .selected)
        let color = hasBackground ? UIColor.highlightedButton : UIColor.clear
        self.setBackgroundImage(image(withColor: color, size: CGSize(width: 1, height: 1)), for: .highlighted)
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment = .center
        self.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func image(withColor color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
}
