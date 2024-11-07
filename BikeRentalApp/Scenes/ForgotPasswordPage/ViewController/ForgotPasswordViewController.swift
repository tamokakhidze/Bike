//
//  ForgotPasswordViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

// MARK: - ForgotPasswordViewController
final class ForgotPasswordViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Sizing.stackViewSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    private var resetPasswordButton = CustomButton(
        title: Titles.resetPasswordTitle,
        hasBackground: true,
        width: Sizing.buttonWidth
    )
    
    private var emailTextField = CustomInputView(inputType: .Email)
    
    // MARK: - Properties
    
    private var viewModel = ForgotPasswordViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        addTargets()
        setDelegates()
    }
    
    // MARK: - Ui setup
    
    private func setupUi() {
        setupView()
        setupViewHierarchy()
        setConstraints()
        configureMainStackView()
        configureEmailTextField()
    }
    
    private func setupView() {
        view.backgroundColor = .mainBackground
    }
    
    private func setupViewHierarchy() {
        view.addSubview(stackView)
    }
    
    private func configureEmailTextField() {
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.textfieldClearBorder.cgColor
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Sizing.stackViewTopConstant)
        ])
    }
    
    private func configureMainStackView() {
        stackView.addArrangedSubviews(
            emailTextField,
            resetPasswordButton,
            UIView()
        )
    }
    
    private func addTargets() {
        resetPasswordButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
        viewModel.delegate = self
    }
    
    // MARK: - Actions
    @objc private func didTapReset() {
        let email = emailTextField.text ?? ""
        viewModel.resetPassword(email: email)
    }
}

// MARK: - UITextFieldDelegate
extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textfieldBlueBorder.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textfieldClearBorder.cgColor
    }
}

// MARK: - ForgotPasswordViewModelDelegate

extension ForgotPasswordViewController: ForgotPasswordViewModelDelegate {
    func didSendPasswordResetEmail(success: Bool, error: String?) {
        if success {
            AlertManager.showAlert(message: Titles.alertMessageOnSuccess, on: self, title: Titles.alertTitle)
        } else if let error = error {
            AlertManager.showAlert(message: error, on: self, title: Titles.alertTitle)
        }
    }
}

// MARK: - Constants extension 

extension ForgotPasswordViewController {
    enum Titles {
        static let resetPasswordTitle = "Reset password"
        static let alertMessageOnSuccess = "Password reset email sent successfully"
        static let alertTitle = "Password reset"
    }
    
    enum Sizing {
        static let titleFontSize: CGFloat = 24
        static let logoSize: CGFloat = 200
        static let stackViewSpacing: CGFloat = 20
        static let stackViewTopPadding: CGFloat = 100
        static let buttonWidth: CGFloat = 350
        static let textFieldBorderWidth: CGFloat = 1
        static let stackViewTopConstant: CGFloat = 350
    }
}
