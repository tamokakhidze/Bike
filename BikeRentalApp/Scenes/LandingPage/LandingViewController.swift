//
//  LandingViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

// MARK: - LandingViewController

final class LandingViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = .landing
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Sizing.titleFontSize, weight: .black)
        label.text = Titles.title
        label.numberOfLines = .zero
        label.textColor = .secondaryText
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Sizing.subtitleFontSize)
        label.text = Titles.subtitle
        label.numberOfLines = .zero
        label.textColor = .secondaryText
        return label
    }()
        
    private var exploreButton = CustomButton(
        title: Titles.exploreTitle,
        hasBackground: true,
        width: Sizing.buttonWidth
    )
    
    private var fullMapButton = CustomButton(
        title: Titles.viewMapTitle,
        hasBackground: true,
        width: Sizing.buttonWidth
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        setupViewHierarchy()
        setConstraints()
        setupStackViewHierarchy()
        addTargets()
    }
    
    // MARK: - UI Setup
    
    private func setupUi() {
        setupView()
        
    }
    
    private func setupView() {
        view.backgroundColor = .mainBackground
        navigationItem.hidesBackButton = true
    }
    
    private func setupViewHierarchy() {
        view.addSubviews(backgroundImage, stackView)
    }
    
    private func setupStackViewHierarchy() {
        stackView.addArrangedSubviews(
            titleLabel,
            subtitleLabel,
            exploreButton,
            fullMapButton
        )
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Sizing.stackViewBottomConstant),
            stackView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func addTargets() {
        exploreButton.addTarget(self, action: #selector(didTapExploreButton), for: .touchUpInside)
        fullMapButton.addTarget(self, action: #selector(didTapFullMapButton), for: .touchUpInside)
    }
    
    // MARK: - Action methods
    
    @objc private func didTapExploreButton() {
        navigationController?.pushViewController(RootViewController(), animated: true)
    }
    
    @objc private func didTapFullMapButton() {
        navigationController?.pushViewController(FullMapViewController(), animated: true)
    }
}

// MARK: - Constants extension

extension LandingViewController {
    enum Titles {
        static let title = "Pedal Through Possibilities"
        static let subtitle = "Explore the City with Ease – Rent a Bike Anytime, Anywhere"
        static let exploreTitle = "Explore now"
        static let viewMapTitle = "View map"
    }
    
    enum Sizing {
        static let titleFontSize: CGFloat = 35
        static let subtitleFontSize: CGFloat = 15
        static let stackViewSpacing: CGFloat = 20
        static let buttonWidth: CGFloat = 350
        static let stackViewBottomConstant: CGFloat = -50
    }
}

#Preview {
    LandingViewController()
}
