//
//  ForgotPasswordViewModel.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import Foundation
import FirebaseAuth

protocol ForgotPasswordViewModelDelegate: AnyObject {
    func didSendPasswordResetEmail(success: Bool, error: String?)
}

final class ForgotPasswordViewModel {
    
    weak var delegate: ForgotPasswordViewModelDelegate?
    
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
