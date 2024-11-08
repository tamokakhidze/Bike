//
//  FeaturesCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 09.07.24.
//

import UIKit

// MARK: - FeaturesCell

class FeaturesCell: UICollectionViewCell {
    
    // MARK: - Ui components and properties

    static let identifier = "FeaturesCell"
    
    private let label: UILabel = {
        let label = CustomUiLabel(fontSize: 14, text: "", tintColor: .darkBackground, textAlignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .darkBackground
        return imageView
    }()
    
    private let details: UILabel = {
        let label = CustomUiLabel(fontSize: 8, text: "", tintColor: .lightGray, textAlignment: .left)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        contentView.addSubview(details)
        
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 49),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 29),
            iconImageView.heightAnchor.constraint(equalToConstant: 27),
            
            details.topAnchor.constraint(equalTo: label.bottomAnchor),
            details.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration

    func configure(with text: String, icon: String, detailsText: String) {
        label.text = text
        iconImageView.image = UIImage(systemName: icon)
        details.text = detailsText
    }
}
