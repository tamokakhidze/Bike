//
//  FeaturesCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 09.07.24.
//

import UIKit

// MARK: - FeaturesCell

class FeaturesCell: UICollectionViewCell {
    
    // MARK: - UI Components and Properties
    
    static let identifier = "FeaturesCell"
    
    private let label: UILabel = {
        let label = CustomUiLabel(
            fontSize: Sizing.labelFontSize,
            text: "",
            tintColor: .darkBackground
        )
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
        let label = CustomUiLabel(
            fontSize: Sizing.detailsFontSize,
            text: "",
            tintColor: Colors.detailsTintColor
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    func setupViewHierarchy() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        contentView.addSubview(details)
    }
    
    func setupView() {
        contentView.layer.borderWidth = Sizing.borderWidth
        contentView.layer.borderColor = Colors.borderColor
        contentView.layer.cornerRadius = Sizing.cornerRadius
        contentView.clipsToBounds = true
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizing.labelTopPadding),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizing.leadingPadding),
            
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Sizing.iconTopPadding),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Sizing.leadingPadding),
            iconImageView.widthAnchor.constraint(equalToConstant: Sizing.iconWidth),
            iconImageView.heightAnchor.constraint(equalToConstant: Sizing.iconHeight),
            
            details.topAnchor.constraint(equalTo: label.bottomAnchor),
            details.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    // MARK: - Configuration
    
    func configure(with text: String, icon: String, detailsText: String) {
        label.text = text
        iconImageView.image = UIImage(systemName: icon)
        details.text = detailsText
    }
}

// MARK: - Constants extension

extension FeaturesCell {
    enum Sizing {
        static let labelFontSize: CGFloat = 14
        static let detailsFontSize: CGFloat = 8
        static let leadingPadding: CGFloat = 16
        static let labelTopPadding: CGFloat = 49
        static let iconTopPadding: CGFloat = 14
        static let iconWidth: CGFloat = 29
        static let iconHeight: CGFloat = 27
        static let borderWidth: CGFloat = 0.5
        static let cornerRadius: CGFloat = 16
    }
    
    enum Colors {
        static let detailsTintColor = UIColor.lightGray
        static let borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
    }
}
