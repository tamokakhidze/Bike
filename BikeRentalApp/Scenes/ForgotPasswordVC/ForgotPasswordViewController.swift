//
//  ForgotPasswordViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

final class ForgotPasswordViewController: UIViewController {
    
    private var resetPasswordButton = CustomButton(title: "Reset password", hasBackground: true, width: 350)
    private var emailTextField = CustomInputView(inputType: .Email)
    private var viewModel = ForgotPasswordViewModel()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        addTargets()
        setDelegates()
    }
    
    private func setupUi() {
        view.backgroundColor = .mainBackground
        configureMainStackView()
        emailTextField.layer.borderWidth = 1.0
        emailTextField.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func addTargets() {
        resetPasswordButton.addTarget(self, action: #selector(didTapReset), for: .touchUpInside)
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
        viewModel.delegate = self
    }
    
    private func configureMainStackView() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 350)
        ])
        stackView.addArrangedSubviews(emailTextField, resetPasswordButton, UIView())
        
    }
    
    
    @objc private func didTapReset() {
        let email = emailTextField.text ?? ""
        viewModel.resetPassword(email: email)
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
    }
}

extension ForgotPasswordViewController: ForgotPasswordViewModelDelegate {
    func didSendPasswordResetEmail(success: Bool, error: String?) {
        if success {
            AlertManager.showAlert(message: "Password reset email sent successfully", on: self, title: "Password reset")
        } else if let error = error {
            AlertManager.showAlert(message: error, on: self, title: "Password reset")
        }
    }
}
