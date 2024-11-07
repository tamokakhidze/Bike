//
//  LoginViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit
import FirebaseAuth
import MapKit
import CoreLocation

// MARK: - LoginViewController

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = LoginViewModel()

    // MARK: - UI Components
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Sizing.stackViewSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .logo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let loginLabel = CustomUiLabel(
        fontSize: Sizing.loginLabelFontSize,
        text: Titles.mainTitleText,
        tintColor: .primaryText,
        fontWeight: .semibold
    )
    
    private let emailTextField = CustomInputView(inputType: .Email)
    
    private let passwordTextField = CustomInputView(inputType: .Password)
    
    private let loginButton = CustomButton(
        title: Titles.loginButtonTitle,
        hasBackground: true,
        width: Sizing.buttonWidth)
    
    private let createAccount = CustomButton(
        title: Titles.createAccButtonTitle,
        hasBackground: false,
        width: Sizing.buttonWidth
    )
    
    private let forgotPassword = CustomButton(
        title: Titles.forgotPasswordTitle,
        hasBackground: false,
        width: Sizing.buttonWidth
    )
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        setDelegates()
        addTargets()
        configureMainStackView()
        addTapGestureToDismissKeyboard()
    }
    
    // MARK: - Setup methods
    
    private func setupUi() {
        setupView()
        configureTextFields()
    }
    
    private func setupView() {
        view.backgroundColor = .mainBackground
        navigationItem.hidesBackButton = true
    }
    
    private func configureTextFields() {
        configureTextField(emailTextField)
        configureTextField(passwordTextField)
    }
    
    private func configureTextField(_ textField: UITextField) {
        textField.layer.borderWidth = Sizing.textFieldBorderWidth
        textField.layer.borderColor = UIColor.textfieldClearBorder.cgColor
    }
    
    private func setDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        viewModel.delegate = self
    }
    
    private func addTargets() {
        loginButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccount.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
        forgotPassword.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    private func configureMainStackView() {
        view.addSubview(stackView)
        stackView.addArrangedSubviews(
            logoImageView,
            loginLabel,
            emailTextField,
            passwordTextField,
            forgotPassword,
            loginButton,
            createAccount,
            UIView()
        )
        setConstraints()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            loginLabel.widthAnchor.constraint(equalToConstant: 350)
        ])
    }
    
    // MARK: - Gesture Recognizers
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapCreateAccount() {
        let registerVC = RegisterViewController()
        navigationController?.pushViewController(registerVC, animated: false)
    }
    
    @objc private func didTapForgotPassword() {
        let forgotPassVC = ForgotPasswordViewController()
        navigationController?.pushViewController(forgotPassVC, animated: false)
    }
    
    @objc private func didTapSignIn() {
        viewModel.signIn()
    }
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textfieldBlueBorder.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textfieldClearBorder.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            didTapSignIn()
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.emailTextField {
            let updatedEmail = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            viewModel.updateEmail(updatedEmail)
        }
        else if textField == self.passwordTextField {
            let updatedPassword = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            viewModel.updatePassword(updatedPassword)
        }
        return true
    }
}

// MARK: - LoginViewModelDelegate

extension LoginViewController: LoginViewModelDelegate {
    func loginWithCredentials(areCredentialsValid: Bool) {
        loginButton.isEnabled = areCredentialsValid
    }
    
    func errorOccurred(_ error: String) {
        AlertManager.showAlert(message: error, on: self, title: "Login Error")
    }
    
    func loginSucceeded() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkIfUserIsLoggedIn()
        }
    }
}

#Preview {
    LoginViewController()
}

private extension LoginViewController {
    enum Sizing {
        static let stackViewSpacing: CGFloat = 20
        static let loginLabelFontSize: CGFloat = 25
        static let buttonWidth: CGFloat = 350
        static let textFieldBorderWidth: CGFloat = 1
    }
    
    enum Titles {
        static let mainTitleText = "Nice to see you again!"
        static let loginButtonTitle = "Sign in"
        static let createAccButtonTitle = "Don't have an account? Sign up now."
        static let forgotPasswordTitle = "Forgot password"
    }
    
}
