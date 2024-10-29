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
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()    
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .logo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var titleLabel = CustomUiLabel(fontSize: 24, text: "Create an account", tintColor: .black, textAlignment: .center)
    private var usernameField = CustomInputView(inputType: .Username)
    private var emailTextField = CustomInputView(inputType: .Email)
    private var passwordTextField = CustomInputView(inputType: .Password)
    private var signUpButton = CustomButton(title: "Sign Up", hasBackground: true, width: 350)
    private var signInButton = CustomButton(title: "Already have an account? Sign in", hasBackground: false, width: 350)
    private var viewModel = RegisterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        addTargets()
        setDelegates()
        addTapGestureToDismissKeyboard()
    }
    
    private func setupUi() {
        view.backgroundColor = .mainBackground
        configureMainStackView()
        navigationItem.hidesBackButton = true
        
        configureTextField(emailTextField)
        configureTextField(passwordTextField)
        configureTextField(usernameField)
    }
    
    private func configureTextField(_ textField: UITextField) {
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.clear.cgColor
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
    
    private func configureMainStackView() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
        ])

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
        textField.layer.borderColor = UIColor.systemBlue.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.clear.cgColor
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
