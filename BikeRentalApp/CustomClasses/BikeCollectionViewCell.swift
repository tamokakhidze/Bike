//
//  BikeCollectionViewCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 24.06.24.
//

import UIKit

class BikeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "BikeCell"
    private var imageView = UIImageView()
    private var priceLabel = UILabel()
    private var priceTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        imageView = configureImageView()
        priceTitleLabel = configurePriceTitleLabel()
        priceLabel = configurePriceLabel()
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
    }
    
    private func configureImageView() -> UIImageView {
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }
    
    private func configurePriceTitleLabel() -> UILabel {
        let label = UILabel()
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Price:"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
        
        return label
    }
    
    private func configurePriceLabel() -> UILabel {
        let label = UILabel()
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .white
        label.font = .systemFont(ofSize: 10, weight: .bold)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: priceTitleLabel.trailingAnchor, constant: 5),
            label.centerYAnchor.constraint(equalTo: priceTitleLabel.centerYAnchor)
        ])
        
        return label
    }
    
    func configureBikeCell(image: String, price: Double) {
        guard let imageUrl = URL(string: image) else { return }
        imageView.setImage(with: imageUrl)
        priceLabel.text = "\(String(format: "%.2f", price))$"
    }
}


