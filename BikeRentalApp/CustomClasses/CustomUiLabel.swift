//
//  CustomLabel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 07.07.24.
//

import UIKit

class CustomUiLabel: UILabel {
    
    init(fontSize: CGFloat, text: String, tintColor: UIColor, textAlignment: NSTextAlignment, fontWeight: UIFont.Weight = .bold) {
        super.init(frame: .zero)
        self.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        self.text = text
        self.textAlignment = textAlignment
        self.textColor = tintColor
        self.numberOfLines = 0
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
