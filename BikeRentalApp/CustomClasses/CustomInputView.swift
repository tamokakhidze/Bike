//
//  CustomInputView.swift
//  BikeRentalApp
//
//  Created by Tamuna Kakhidze on 03.07.24.
//

import UIKit

// MARK: - CustomInputView

class CustomInputView: UITextField {
    
    // MARK: - Enum
    enum InputViewType: CaseIterable {
        case Username, Email, Password
    }
    
    // MARK: - UI Components and Properties
    
    private var inputFieldType: InputViewType
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = Colors.iconTintColor
        imageView.contentMode = .center
        return imageView
    }()
    
    // MARK: - Init
    
    init(inputType: InputViewType ) {
        self.inputFieldType = inputType
        super.init(frame: .zero)
        configureKeyboard()
        configureAppearance()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configurations
    private func configureKeyboard() {
        self.autocapitalizationType = .none
        self.autocorrectionType = .no
        self.returnKeyType = .done
    }
    
    private func configureAppearance() {
        self.font = Fonts.inputFont
        self.leftView = imageView
        self.leftViewMode = .always
        self.layer.cornerRadius = Sizing.cornerRadius
        self.backgroundColor = .input
        
        let placeholderText: String
        
        switch inputFieldType {
        case .Username:
            placeholderText = Placeholders.username
            self.imageView.image = UIImage(systemName: "person")
        case .Email:
            placeholderText = Placeholders.email
            self.keyboardType = .emailAddress
            self.imageView.image = UIImage(systemName: "envelope")
        case .Password:
            placeholderText = Placeholders.password
            self.isSecureTextEntry = true
            self.textContentType = .oneTimeCode
            self.imageView.image = UIImage(systemName: "lock")

        }
        
        configurePlaceholder(placeholderText: placeholderText)
    }
    
    private func setConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.widthAnchor.constraint(equalToConstant: Sizing.iconWidth),
            self.imageView.heightAnchor.constraint(equalToConstant: Sizing.iconHeight),
            self.heightAnchor.constraint(equalToConstant: Sizing.inputHeight),
            self.widthAnchor.constraint(equalToConstant: Sizing.inputWidth)
        ])
    }
    
    private func configurePlaceholder(placeholderText: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.placeholderTextColor
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}

// MARK: - Constants Extension

extension CustomInputView {
    enum Sizing {
        static let cornerRadius: CGFloat = 10
        static let iconWidth: CGFloat = 40
        static let iconHeight: CGFloat = 30
        static let inputHeight: CGFloat = 50
        static let inputWidth: CGFloat = 350
    }
    
    enum Colors {
        static let iconTintColor = UIColor.lightGray
        static let placeholderTextColor = UIColor.gray
    }
    
    enum Fonts {
        static let inputFont = UIFont.systemFont(ofSize: 14)
    }
    
    enum Placeholders {
        static let username = "Enter username"
        static let email = "Enter email"
        static let password = "Enter password"
    }
}
