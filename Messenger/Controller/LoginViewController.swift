//
//  LoginViewController.swift
//  Messenger
//
//  Created by MW on 12/12/19.
//  Copyright © 2019 MW. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let screen = UIScreen.main.bounds
    
    private lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(registrationButtonPressed), for: .touchUpInside)
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
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        textField.attributedPlaceholder = .init(string: "jan.kowalski@gmail.com", attributes: [NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)])
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
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.textColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        textField.attributedPlaceholder = .init(string: "******************", attributes: [NSAttributedString.Key.foregroundColor : UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1)])
        textField.layer.borderColor = CGColor(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 10
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "arr")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        navigationItem.setHidesBackButton(true, animated: true)
        setupObjects()
        setupNotifications()
        autoLogIn()

    }
    
    func autoLogIn() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if Auth.auth().currentUser != nil {
                self.navigationController?.pushViewController(UserViewController(), animated: true)
            }
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
               
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
               
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        view.frame.origin.y = isKeyboardShowing ? -200 : 0
    }
    
    @objc func loginButtonPressed() {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
        
            if error != nil {
                let alert = UIAlertController(title: "Error!", message: "An error occurred during the login process!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            } else {
                self.navigationController?.pushViewController(UserViewController(), animated: true)
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
            }
        }
    }
    
    @objc func registrationButtonPressed() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    func setupObjects() {
        
        [registerButton, logoImage, logoTitle, logoSubTitle, emailLabel, emailTextField, passwordLabel, passwordTextField, loginButton].forEach{view.addSubview($0)}
        
        registerButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: screen.height * 0.015, left: 0, bottom: 0, right: screen.width * 0.05), size: .init(width: 0, height: screen.height * 0.05))
        
        logoImage.anchor(top: registerButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: screen.height * 0.045, left: screen.width * 0.3, bottom: 0, right: screen.width * 0.3), size: .init(width: 0, height: screen.height * 0.2))
        
        logoTitle.anchor(top: logoImage.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: screen.width * 0.2, bottom: 0, right: screen.width * 0.2))
        
        logoSubTitle.anchor(top: logoTitle.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: screen.width * 0.2, bottom: 0, right: screen.width * 0.2))
        
        emailLabel.anchor(top: logoSubTitle.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: screen.height * 0.19, left: screen.width * 0.05, bottom: 0, right: 0), size: .init(width: screen.width * 0.4, height: screen.height * 0.02))
        
        emailTextField.anchor(top: emailLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: screen.height * 0.005, left: screen.width * 0.05, bottom: 0, right: screen.width * 0.05), size: .init(width: 0, height: screen.height * 0.065))
        
        passwordLabel.anchor(top: emailTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: screen.height * 0.02, left: screen.width * 0.05, bottom: 0, right: 0), size: .init(width: 0, height: screen.height * 0.02))
        
        passwordTextField.anchor(top: passwordLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: loginButton.leadingAnchor, padding: .init(top: screen.height * 0.005, left: screen.width * 0.05, bottom: 0, right: screen.width * 0.05), size: .init(width: 0, height: screen.height * 0.065))
        
        loginButton.anchor(top: passwordLabel.bottomAnchor, leading: passwordTextField.trailingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: screen.height * 0.005, left: screen.width * 0.01, bottom: 0, right: screen.width * 0.05), size: .init(width: screen.width * 0.15, height: screen.height * 0.065))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}

