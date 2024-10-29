//
//  CustomBackgroundView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import UIKit

class CustomRectangleView: UIView {

    init(color: UIColor) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.setCornerRadius(corners: [.topLeft, .topRight], radius: 40)
        self.layer.masksToBounds = true
    }
}


