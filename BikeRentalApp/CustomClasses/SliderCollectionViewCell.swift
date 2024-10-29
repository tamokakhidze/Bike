//
//  SliderCollectionViewCell.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 28.06.24.
//

import UIKit

class SliderCollectionViewCell: UICollectionViewCell {
    
    private lazy var heroText: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 28, weight: .bold)
        textLabel.textColor = .white
        textLabel.textAlignment = .left
        textLabel.numberOfLines = 2
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    private lazy var subText: UILabel = {
        let textLabel = UILabel()
        textLabel.font = .systemFont(ofSize: 15, weight: .medium)
        textLabel.textColor = .lightGray
        textLabel.textAlignment = .left
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()
    
    var images = UIImageView()
    static var identifier = "SliderCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        images = configureImageView()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
    }
    
    private func configureImageView() -> UIImageView {
        let imageView = UIImageView()
        contentView.addSubview(imageView)
        contentView.addSubview(heroText)
        contentView.addSubview(subText)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            heroText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            heroText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            
            subText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subText.topAnchor.constraint(equalTo: heroText.bottomAnchor, constant: 5)
        ])
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        
        return imageView
    }
    
    
    func configureSliderCell(imageURL: String, text: String, subtext: String) {
        guard let imageURL = URL(string: imageURL) else { return }
        images.setImage(with: imageURL)
        heroText.text = text
        subText.text = subtext
    }
}

#Preview {
    SliderCollectionViewCell()
}
