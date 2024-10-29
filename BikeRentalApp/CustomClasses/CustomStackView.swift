//
//  CustomStackView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 08.07.24.
//

import UIKit

class CustomStackView: UIStackView {
    
    init(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution = .fill) {
        super.init(frame: .zero)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
