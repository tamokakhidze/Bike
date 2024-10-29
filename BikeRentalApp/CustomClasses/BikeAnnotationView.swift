//
//  BikeAnnotationView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 10.07.24.
//

import UIKit
import MapKit

class BikeAnnotationView: MKAnnotationView {
    
    private let titleLabel = UILabel()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: topAnchor, constant: -5)
        ])
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
    }
    
    func configure(with annotation: MKAnnotation?) {
        titleLabel.text = annotation?.title ?? ""
        titleLabel.sizeToFit()
    }
}
