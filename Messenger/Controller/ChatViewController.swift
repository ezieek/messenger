//
//  ViewController.swift
//  Messenger
//
//  Created by MW on 12/10/19.
//  Copyright © 2019 MW. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "reuseCell"
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

    lazy var chatCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cc = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cc.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        cc.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cc.dataSource = self
        cc.delegate = self
        return cc
    }()
    
    lazy var mainView: UIView = {
        let mv = UIView()
        return mv
    }()
    
    lazy var messageTextField: UITextField = {
        let mt = UITextField(frame: .zero)
        mt.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        mt.attributedPlaceholder = NSAttributedString(string: "Put your text here", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)])
        mt.textAlignment = .center
        mt.layer.borderWidth = 1
        mt.layer.borderColor = CGColor(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        mt.layer.cornerRadius = 10
        mt.layer.masksToBounds = true
        mt.autocorrectionType = .no
        return mt
    }()
    
    lazy var sendButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.setTitle("Wyslij", for: .normal)
        sb.setTitleColor(UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
        sb.layer.borderWidth = 1
        sb.layer.borderColor = CGColor(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        sb.layer.cornerRadius = 10
        sb.layer.masksToBounds = true
        sb.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
        return sb
    }()
    
    lazy var backButton: UIButton = {
        let bb = UIButton(type: .system)
        bb.setTitle("OK", for: .normal)
        bb.setTitleColor(UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1), for: .normal)
        bb.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        return bb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        if titleName == nil {
            titleName = ""
        }
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        navigationItem.title = titleName!
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationItem.hidesBackButton = true
        setupObjects()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tapGestureRecognizer.delegate = self
        
        self.chatCollectionView.addGestureRecognizer(tapGestureRecognizer)
        
         NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
               
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
               
        bottomConstraint = NSLayoutConstraint(item: mainView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)

        loadMessages()
        
    }
        
    override func viewDidLayoutSubviews() {
        let section = 0
        let lastItemIndex = self.chatCollectionView.numberOfItems(inSection: section) - 1
        let indexPath:NSIndexPath = NSIndexPath.init(item: lastItemIndex, section: section)
        self.chatCollectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
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
                        self.chatCollectionView.reloadData()
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
                                "messageText": messageTextField.text as Any,
                                "timestamp": Int(Date().timeIntervalSince1970)] as [String : Any]
        
        if messageTextField.text != "" {
            refMessage.updateChildValues(valuesForMessage as [AnyHashable : Any])
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
                let userSnap = snap as! DataSnapshot
                let uid = userSnap.key
                Database.database().reference().child("users").child("savedFriends")
                    .child((Auth.auth().currentUser?.displayName)!)
                    .child(uid)
                    .updateChildValues(["messageText": self.messageTextField.text as Any, "timestamp": Int(Date().timeIntervalSince1970)])
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.messageTextField.text = ""
        }
    }

    @objc func keyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame.height + 50 : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }) { (completion) in
                let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
                self.chatCollectionView.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            }
        }
    }
    
    @objc func dismissKeyboard(gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func setupObjects() {
        [chatCollectionView, mainView].forEach({view.addSubview($0)})
        
        chatCollectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: mainView.topAnchor, trailing: view.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10), size: .init(width: screen.width, height: 0))
        
        mainView.anchor(top: chatCollectionView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .zero, size: .init(width: screen.width, height: 100))

        [messageTextField, sendButton].forEach({mainView.addSubview($0)})
        
        messageTextField.anchor(top: mainView.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: screen.width * 0.01, bottom: 0, right: 0), size: .init(width: screen.width * 0.79, height: screen.height * 0.05))
        
        sendButton.anchor(top: mainView.topAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: screen.width * 0.01), size: .init(width: screen.width * 0.19, height: screen.height * 0.05))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextField.resignFirstResponder()
    }
    
}

extension ChatViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatCollectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        cell.message = message
        textMessage = messages[indexPath.row].messageText
        
        if message.fromUser == Auth.auth().currentUser?.uid {
            cell.textLabel1.textAlignment = .left
            cell.textLabel1.textColor = .black
            return cell
        } else {
            cell.textLabel1.textAlignment = .right
            cell.textLabel1.textColor = .white
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let estimatedFrame = NSString(string: messages[indexPath.item].messageText ?? "").boundingRect(with: CGSize(width: screen.width * 0.7, height: 100), options: NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], context: nil)
        
        return CGSize(width: screen.width, height: estimatedFrame.height + 20)

    }

}

