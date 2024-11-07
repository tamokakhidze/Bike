//
//  RegisterViewController.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit
import FirebaseAuth

final class RegisterViewController: UIViewController {
    
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
    
    private lazy var titleLabel = CustomUiLabel(
        fontSize: Sizing.titleFontSize,
        text: Titles.createAccountText,
        tintColor: .black,
        textAlignment: .center
    )
    
    private var signUpButton = CustomButton(
        title: Titles.signUp,
        hasBackground: true,
        width: Sizing.buttonWidth
    )
    
    private var signInButton = CustomButton(
        title: Titles.signIn,
        hasBackground: false,
        width: Sizing.buttonWidth
    )
    
    private var usernameField = CustomInputView(inputType: .Username)
    
    private var emailTextField = CustomInputView(inputType: .Email)
    
    private var passwordTextField = CustomInputView(inputType: .Password)
    
    private var viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        addTargets()
        setDelegates()
        addTapGestureToDismissKeyboard()
    }
    
    private func setupUi() {
        setupView()
        setupViewHierarchy()
        setConstraints()
        setupStackView()
        configureTextField(emailTextField)
        configureTextField(passwordTextField)
        configureTextField(usernameField)
    }
    
    private func setupView() {
        view.backgroundColor = .mainBackground
        navigationItem.hidesBackButton = true
    }
    
    private func configureTextField(_ textField: UITextField) {
        textField.layer.borderWidth = Sizing.textFieldBorderWidth
        textField.layer.borderColor = UIColor.textfieldClearBorder.cgColor
    }
    
    private func addTargets() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }
    
    private func setDelegates() {
        usernameField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        viewModel.delegate = self
    }
    
    private func setupViewHierarchy() {
        view.addSubview(stackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    private func setupStackView() {
        stackView.addArrangedSubviews(
            logoImageView,
            titleLabel,
            emailTextField,
            usernameField,
            passwordTextField,
            signUpButton,
            signInButton,
            UIView()
        )
    }
    
    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapSignUp() {
        viewModel.registerUser(username: usernameField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
    }
    
    @objc private func didTapSignIn() {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textfieldBlueBorder.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.textfieldClearBorder.cgColor
    }
}

extension RegisterViewController: RegisterViewModelDelegate {
    func registrationCompleted(success: Bool, error: Error?) {
        if success {
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkIfUserIsLoggedIn()
            }
        } else {
            if let error = error {
                AlertManager.showAlert(message: error.localizedDescription, on: self, title: "Registration error")
            } else {
                AlertManager.showAlert(message: "Registration failed.", on: self, title: "Registration error")
            }
        }
    }
}

extension RegisterViewController {
    enum Titles {
        static let createAccountText = "Create an account"
        static let signUp = "Sign Up"
        static let signIn = "Already have an account? Sign in"
    }
    
    enum Colors {
        static let titleTextColor = UIColor.black
        static let backgroundColor = UIColor.mainBackground
        static let borderColor = UIColor.clear.cgColor
        static let activeBorderColor = UIColor.systemBlue.cgColor
    }
    
    enum Sizing {
        static let titleFontSize: CGFloat = 24
        static let logoSize: CGFloat = 200
        static let stackViewSpacing: CGFloat = 20
        static let stackViewTopPadding: CGFloat = 100
        static let buttonWidth: CGFloat = 350
        static let textFieldBorderWidth: CGFloat = 1
    }
}
