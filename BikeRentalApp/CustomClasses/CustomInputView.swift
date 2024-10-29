//
//  CustomInputView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

class CustomInputView: UITextField {
    
    enum InputViewType: CaseIterable {
        case Username, Email, Password
    }
    
    private var inputFieldType: InputViewType
    
    var imageView = UIImageView()
    
    init(inputType: InputViewType ) {
        self.inputFieldType = inputType
        super.init(frame: .zero)
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.returnKeyType = .done
        self.font = .systemFont(ofSize: 14)
        self.imageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leftView = imageView
        self.imageView.tintColor = .lightGray
        self.imageView.contentMode = .center
        self.leftViewMode = .always
        
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
        self.widthAnchor.constraint(equalToConstant: 350).isActive = true
        
        self.layer.cornerRadius = 10
        
        self.backgroundColor = .input
        
        let placeholderText: String
        switch inputFieldType {
        case .Username:
            placeholderText = "Enter username"
            self.imageView.image = UIImage(systemName: "person")
        case .Email:
            placeholderText = "Enter email"
            self.keyboardType = .emailAddress
            self.imageView.image = UIImage(systemName: "envelope")
        case .Password:
            placeholderText = "Enter password"
            self.isSecureTextEntry = true
            self.textContentType = .oneTimeCode
            self.imageView.image = UIImage(systemName: "lock")

        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.gray
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


#Preview {
    LoginViewController()
}
