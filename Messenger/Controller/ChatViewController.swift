//
//  ViewController.swift
//  Messenger
//
//  Created by MW on 12/10/19.
//  Copyright © 2019 MW. All rights reserved.
//

import UIKit
import Firebase

private let screen = UIScreen.main.bounds

class ChatViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var messages: [Message] = []
    var nameReceived: String?
    var emailReceived: String?
    var uidReceived: String?
    var titleName: String?
    var userViewController: UserViewController?
    var textMessage: String?
    var bottomConstraint: NSLayoutConstraint?
    let initObjects = ChatView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        initObjects.chatCollectionView.delegate = self
        initObjects.chatCollectionView.dataSource = self
        initObjects.sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        initObjects.backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        setupNavigatonBar()
        setupNotifications()
        loadMessages()
    }
    
    override func loadView() {
        super.loadView()
        
        view = initObjects
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let section = 0
        let lastItemIndex = self.initObjects.chatCollectionView.numberOfItems(inSection: section) - 1
        let indexPath: NSIndexPath = NSIndexPath.init(item: lastItemIndex, section: section)
        self.initObjects.chatCollectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    func setupNavigatonBar() {
        if titleName == nil {
            titleName = ""
        }
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        navigationItem.title = titleName!
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: initObjects.backButton)
        navigationItem.hidesBackButton = true
    }
    
    func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGestureRecognizer.delegate = self
        initObjects.chatCollectionView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        bottomConstraint = NSLayoutConstraint(item: initObjects.mainView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
    }
    
    func loadMessages() {
        messages = []
        
        Database.database().reference().child("messages").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                var message = Message()
                message.fromUser = dictionary["fromUser"] as? String
                message.toUser = dictionary["toUser"] as? String
                message.messageText = dictionary["messageText"] as? String
                message.timestamp = dictionary["timestamp"] as? NSNumber
                
                if (message.toUser == self.uidReceived && message.fromUser == Auth.auth().currentUser!.uid) || (message.fromUser == self.uidReceived && message.toUser == Auth.auth().currentUser!.uid) {
                    
                    if message.toUser != Auth.auth().currentUser?.uid {
                        message.messageText = "Ty: \(message.messageText!)"
                    } else {
                        message.messageText = message.messageText!
                    }
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.initObjects.chatCollectionView.reloadData()
                    }
                }
            }
            
        }, withCancel: nil)
    }
    
    @objc func backButtonPressed() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.navigationController?.pushViewController(UserViewController(), animated: true)
        })
    }
    
    func sendingMessage() {
        let refMessage = Database.database().reference().child("messages").childByAutoId()
        let valuesForMessage = ["fromUser": Auth.auth().currentUser?.uid as Any,
                                "toUser": uidReceived as Any,
                                "messageText": initObjects.messageTextField.text as Any,
                                "timestamp": Int(Date().timeIntervalSince1970)] as [String: Any]
        
        if initObjects.messageTextField.text != "" {
            refMessage.updateChildValues(valuesForMessage as [AnyHashable: Any])
        }
    }
    
    @objc func sendButtonPressed() {
        sendingMessage()

        let queryRef = Database.database().reference().child("users").child("savedFriends")
            .child((Auth.auth().currentUser?.displayName)!)
            .queryOrdered(byChild: "messageToUserID")
            .queryEqual(toValue: uidReceived)

        queryRef.observeSingleEvent(of: .value) { (snapshot) in
            for snap in snapshot.children {
                let userSnap = snap as? DataSnapshot
                guard let uid = userSnap?.key else { return }
                Database.database().reference().child("users").child("savedFriends")
                    .child((Auth.auth().currentUser?.displayName)!)
                    .child(uid)
                    .updateChildValues(["messageText": self.initObjects.messageTextField.text as Any, "timestamp": Int(Date().timeIntervalSince1970)])
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.initObjects.messageTextField.text = ""
        }
    }

    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -(keyboardFrame?.height ?? 0) + 50 : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                self.initObjects.chatCollectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            }
        }
    }
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        initObjects.messageTextField.resignFirstResponder()
    }
}

extension ChatViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = initObjects.chatCollectionView.dequeueReusableCell(withReuseIdentifier: initObjects.reuseIdentifier, for: indexPath) as? MessageCell else { return UICollectionViewCell() }
        
        let message = messages[indexPath.row]
        cell.textLabel.text = message.messageText
        textMessage = message.messageText
        
        if message.fromUser == Auth.auth().currentUser?.uid {
            cell.textLabel.textAlignment = .left
            cell.textLabel.textColor = .black
            return cell
        } else {
            cell.textLabel.textAlignment = .right
            cell.textLabel.textColor = .white
            return cell
        }
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let estimatedFrame = NSString(string: messages[indexPath.item].messageText ?? "").boundingRect(with: CGSize(width: screen.width * 0.7, height: 100), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], context: nil)
        return CGSize(width: screen.width, height: estimatedFrame.height + 20)
    }

}
