//
//  LoginView.swift
//  Messenger
//
//  Created by Maciej Wołejko on 19/05/2020.
//  Copyright © 2020 user161709. All rights reserved.
//

import UIKit

class LoginView: UIView {

    let screen = UIScreen.main.bounds
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New Account? Sign up!", for: .normal)
        button.setTitleColor(UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()

    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "as1-2")?.withRenderingMode(.alwaysOriginal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var logoTitle: UILabel = {
        let label = UILabel()
        label.text = "Messenger"
        label.font = .boldSystemFont(ofSize: screen.width * 0.1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var logoSubTitle: UILabel = {
        let label = UILabel()
        label.text = "by mwsoftware"
        label.font = .systemFont(ofSize: 25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Put your email here"
        label.font = .systemFont(ofSize: screen.width * 0.035)
        label.textColor = UIColor(white: 1, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        textField.attributedPlaceholder = .init(string: "jan.kowalski@gmail.com", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)])
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Put your password here"
        label.font = .systemFont(ofSize: screen.width * 0.035)
        label.textColor = UIColor(white: 1, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        textField.attributedPlaceholder = .init(string: "******************", attributes: [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)])
        textField.layer.borderColor = CGColor(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "arr")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func createSubViews() {
        
        [registerButton, logoImage, logoTitle, logoSubTitle, emailLabel, emailTextField, passwordLabel, passwordTextField, loginButton].forEach { addSubview($0) }
        
        registerButton.anchor(top: safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: screen.height * 0.015, left: 0, bottom: 0, right: screen.width * 0.05), size: .init(width: 0, height: screen.height * 0.05))
        
        logoImage.anchor(top: registerButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: screen.height * 0.045, left: screen.width * 0.3, bottom: 0, right: screen.width * 0.3), size: .init(width: 0, height: screen.height * 0.2))
        
        logoTitle.anchor(top: logoImage.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: screen.width * 0.2, bottom: 0, right: screen.width * 0.2))
        
        logoSubTitle.anchor(top: logoTitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: screen.width * 0.2, bottom: 0, right: screen.width * 0.2))
        
        emailLabel.anchor(top: logoSubTitle.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: screen.height * 0.19, left: screen.width * 0.05, bottom: 0, right: 0), size: .init(width: screen.width * 0.4, height: screen.height * 0.02))
        
        emailTextField.anchor(top: emailLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: screen.height * 0.005, left: screen.width * 0.05, bottom: 0, right: screen.width * 0.05), size: .init(width: 0, height: screen.height * 0.065))
        
        passwordLabel.anchor(top: emailTextField.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: screen.height * 0.02, left: screen.width * 0.05, bottom: 0, right: 0), size: .init(width: 0, height: screen.height * 0.02))
        
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: loginButton.leadingAnchor, padding: .init(top: screen.height * 0.005, left: screen.width * 0.05, bottom: 0, right: screen.width * 0.05), size: .init(width: 0, height: screen.height * 0.065))
        
        loginButton.anchor(top: passwordLabel.bottomAnchor, leading: passwordTextField.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: screen.height * 0.005, left: screen.width * 0.01, bottom: 0, right: screen.width * 0.05), size: .init(width: screen.width * 0.15, height: screen.height * 0.065))
    }
}

extension LoginView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
    }
}
