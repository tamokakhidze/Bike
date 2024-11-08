//
//  SuccessViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 11.07.24.
//

import UIKit

// MARK: - SuccessViewController

final class SuccessViewController: UIViewController {

    // MARK: - Ui components and properties

    private var goToHomeButton = CustomButton(title: "Go to Home page", hasBackground: true, width: 350)
    private var stackView = UIStackView()
    private var titleLabel = CustomUiLabel(fontSize: 28, text: "Payment Success", tintColor: .black, textAlignment: .left, fontWeight: .medium)
    private var smallTitle = CustomUiLabel(fontSize: 14, text: "Your rentals will be available on profile", tintColor: .lightGray, textAlignment: .center, fontWeight: .semibold)

    private lazy var successImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "successImage")
        return imageView
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        addTargets()
    }
    
    // MARK: - Ui setup

    private func setupUi() {
        view.backgroundColor = .loginBackground
        stackView = configureMainStackView()
        navigationItem.hidesBackButton = true
    }
    
    private func configureMainStackView() -> UIStackView {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        view.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        stackView.addArrangedSubviews(successImage, titleLabel, smallTitle, goToHomeButton, UIView())
        
        return stackView
    }
    
    // MARK: - Actions

    private func addTargets() {
        goToHomeButton.addTarget(self, action: #selector(didTapGoToHomePage), for: .touchUpInside)
    }
    
    
    @objc private func didTapGoToHomePage() {
        let vc = RootViewController()
        navigationController?.pushViewController(vc, animated: false)
    }
}

#Preview {
    SuccessViewController()
}
