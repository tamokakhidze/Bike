//
//  UIViewExtensions.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 07.11.24.
//

import UIKit

extension UIView {
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            addSubview(subview)
        }
    }
}
