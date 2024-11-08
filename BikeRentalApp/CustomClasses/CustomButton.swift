//
//  CustomButton.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

// MARK: - CustomButton

class CustomButton: UIButton {
    
    // MARK: - Init
    
    init(title: String, hasBackground: Bool = false, width: CGFloat) {
        super.init(frame: .zero)
        configureTitle(title, hasBackground: hasBackground)
        configureAppearance(hasBackground: hasBackground, width: width)
        configureSelectedState(hasBackground: hasBackground)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurations
    
    private func configureTitle(_ title: String, hasBackground: Bool) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: hasBackground ? Sizing.titleFontLarge : Sizing.titleFontSmall, weight: .bold)
        self.setTitleColor(hasBackground ? Colors.textOnBackground : Colors.primaryText, for: .normal)
        self.setTitleColor(Colors.disabledText, for: .selected)
    }
    
    private func configureAppearance(hasBackground: Bool, width: CGFloat) {
        self.backgroundColor = hasBackground ? Colors.background: .clear
        self.heightAnchor.constraint(equalToConstant: hasBackground ? Sizing.largeHeight : Sizing.smallHeight).isActive = true
        self.widthAnchor.constraint(equalToConstant: width).isActive = true
        self.layer.cornerRadius = Sizing.cornerRadius
        self.clipsToBounds = true
        self.contentHorizontalAlignment = .center
        self.contentVerticalAlignment = .center
    }
    
    private func configureSelectedState(hasBackground: Bool) {
        let color = hasBackground ? UIColor.highlightedButton : .clear
        self.setBackgroundImage(image(withColor: color, size: CGSize(width: 1, height: 1)), for: .highlighted)
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

// MARK: - Constants Extension

extension CustomButton {
    enum Sizing {
        static let cornerRadius: CGFloat = 25
        static let largeHeight: CGFloat = 50
        static let smallHeight: CGFloat = 25
        static let titleFontLarge: CGFloat = 14
        static let titleFontSmall: CGFloat = 12
    }
    
    enum Colors {
        static let background = UIColor.black
        static let highlightedBackground = UIColor.highlightedButton
        static let textOnBackground = UIColor.white
        static let primaryText = UIColor.systemBlue
        static let disabledText = UIColor.systemGray
    }
}
