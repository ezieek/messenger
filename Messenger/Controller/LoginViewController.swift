//
//  LoginViewController.swift
//  Messenger
//
//  Created by MW on 12/12/19.
//  Copyright © 2019 MW. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let screen = UIScreen.main.bounds
    let initObjects = LoginView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        navigationItem.setHidesBackButton(true, animated: true)
        initObjects.registerButton.addTarget(self, action: #selector(registrationButtonPressed), for: .touchUpInside)
        initObjects.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        setupNotifications()
        autoLogIn()

    }
    
    override func loadView() {
        super.loadView()
        
        view = initObjects
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
        
        Auth.auth().signIn(withEmail: initObjects.emailTextField.text!, password: initObjects.passwordTextField.text!) { (_, error) in
        
            if error != nil {
                let alert = UIAlertController(title: "Error!", message: "An error occurred during the login process!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true)
                self.initObjects.emailTextField.text = ""
                self.initObjects.passwordTextField.text = ""
            } else {
                self.navigationController?.pushViewController(UserViewController(), animated: true)
                self.initObjects.emailTextField.text = ""
                self.initObjects.passwordTextField.text = ""
            }
        }
    }
    
    @objc func registrationButtonPressed() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        initObjects.emailTextField.resignFirstResponder()
        initObjects.passwordTextField.resignFirstResponder()
    }
}
