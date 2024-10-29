//
//  LoginViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import Foundation

// MARK: - Protocols

protocol LoginViewModelDelegate: AnyObject {
    func loginWithCredentials(areCredentialsValid: Bool)
    func errorOccurred(_ error: String)
    func loginSucceeded()
}

// MARK: - LoginViewModel

class LoginViewModel {
    
    // MARK: - Properties
    
    private var email = ""
    private var password = ""
    private var areCredentialsValid = false
    
    weak var delegate: LoginViewModelDelegate?
    
    // MARK: - Methods
    
    func updateEmail(_ email: String) {
        self.email = email
        validateFields()
    }
    
    func updatePassword(_ password: String) {
        self.password = password
        validateFields()
    }
    
    private func validateFields() {
        areCredentialsValid = !email.isEmpty && !password.isEmpty
        delegate?.loginWithCredentials(areCredentialsValid: areCredentialsValid)
    }
    
    func signIn() {
        guard areCredentialsValid else { return }
        let loginRequest = LoginRequest(email: email, password: password)
        
        AuthService.shared.signIn(with: loginRequest) { [weak self] error in
            if let error = error {
                self?.delegate?.errorOccurred(error.localizedDescription)
                return
            }
            else {
                self?.delegate?.loginSucceeded()
            }
        }
    }
}
