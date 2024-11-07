//
//  ForgotPasswordViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import Foundation
import FirebaseAuth

// MARK: - Protocols

protocol ForgotPasswordViewModelDelegate: AnyObject {
    func didSendPasswordResetEmail(success: Bool, error: String?)
}

// MARK: - ForgotPasswordViewModel

final class ForgotPasswordViewModel {
    
    // MARK: - Properties
    
    weak var delegate: ForgotPasswordViewModelDelegate?
    
    // MARK: - Methods
    func resetPassword(email: String) {
        AuthService.shared.forgotPassword(with: email) { [weak self] error in
            if let error = error {
                self?.delegate?.didSendPasswordResetEmail(success: false, error: error.localizedDescription)
            } else {
                self?.delegate?.didSendPasswordResetEmail(success: true, error: nil)
            }
        }
    }
}
