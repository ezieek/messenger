//
//  RegisterViewController.swift
//  Messenger
//
//  Created by MW on 12/12/19.
//  Copyright © 2019 MW. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    var loginViewController = LoginViewController()
    let screen = UIScreen.main.bounds
    let initObjects = RegisterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        navigationItem.setHidesBackButton(true, animated: true)
        initObjects.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        initObjects.signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        setupNotifications()
    }
    
    override func loadView() {
        super.loadView()
        
        view = initObjects
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
    
    @objc func loginButtonPressed() {
        
        self.navigationController?.pushViewController(LoginViewController(), animated: true)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
       
        let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
        view.frame.origin.y = isKeyboardShowing ? -200 : 0
    }
    
    @objc func signUpButtonPressed() {
        
        guard let email = initObjects.emailTextField.text else { return }
        guard let password = initObjects.passwordTextField.text else { return }
        guard let name = initObjects.nameTextField.text else { return }
        let date = Int(Date().timeIntervalSince1970)
        
        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error!", message: "An error occurred during the registration process!", preferredStyle: .alert)
                let action = UIAlertAction(title: "Try again", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true)
            } else {
                let ref = Database.database().reference().child("users").child("allRegisteredUsers").childByAutoId()
                let values = ["myName": name as Any, "myEmail": email as Any, "myUid": Auth.auth().currentUser?.uid as Any, "date": date]
                ref.updateChildValues(values as [AnyHashable: Any]) { (err, _) in
                    if err != nil {
                        print(err as Any)
                    } else {
                        print("Successfully added user")
                    }
                }
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = name
                changeRequest?.commitChanges(completion: { (err) in
                    if err != nil {
                        print("There is an error commiting changes of user profile!")
                    } else {
                        print("Everything works fine")
                    }
                })
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        initObjects.emailTextField.resignFirstResponder()
        initObjects.passwordTextField.resignFirstResponder()
    }
}
