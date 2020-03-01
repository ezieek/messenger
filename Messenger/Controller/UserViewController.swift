//
//  UserViewController.swift
//  Messenger
//
//  Created by MW on 13/01/2020.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "reuseCell"

class UserViewController: UIViewController {
    
    var users = [User]()
    let screen = UIScreen.main.bounds
    var loginViewController = LoginViewController()
    var userNameUsed: [String] = Array()
    
    lazy var userTableView : UITableView = {
        let tv = UITableView()
        tv.separatorColor = .white
        tv.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        tv.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        setupNavBar()
        setupObjects()
        fetchingOnlySavedFriends()
    }
    
    func setupNavBar() {
        navigationItem.setHidesBackButton(true, animated: true)
        
        let logoutButton = UIButton(type: .system)
        logoutButton.setTitleColor(UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1), for: .normal)
        let string = NSAttributedString(string: "Logout", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor(red: 230/255, green: 126/255, blue: 34/255, alpha: 1)])
        logoutButton.setAttributedTitle(string, for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logoutButton)
        
        let composeButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMessageButtonPressed))
        composeButton.tintColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        navigationItem.rightBarButtonItem = composeButton
    }
    
    @objc func logoutButtonPressed() {
        do {
            try Auth.auth().signOut()
            navigationController?.pushViewController(LoginViewController(), animated: true)
        } catch {
            print("There is an error Signing Out!")
        }
    }
    
    func setupObjects() {
        
        [userTableView].forEach({view.addSubview($0)})
        
        userTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: -10, bottom: 0, right: 10), size: .init(width: screen.width, height: 0))
    }

    @objc func newMessageButtonPressed() {
        let vc = NewMessageViewController()
        vc.userNameUsed = userNameUsed
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchingOnlySavedFriends() {
        Database.database().reference().child("users").child("savedFriends")
            .child((Auth.auth().currentUser?.displayName)!)
            .observe(.childAdded, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: AnyObject] {
                var user = User()
                user.messageFromUser = dictionary["messageFromUser"] as? String
                user.messageText = dictionary["messageText"] as? String
                user.messageToUser = dictionary["messageToUser"] as? String
                user.messageToUserID = dictionary["messageToUserID"] as? String
                user.addedUserEmail = dictionary["addedUserEmail"] as? String
                user.timestamp = dictionary["timestamp"] as? NSNumber
                user.userEmail = dictionary["userEmail"] as? String
                user.userID = dictionary["userID"] as? String
                
                Database.database().reference().child("users").child("savedFriends")
                .child(user.messageToUser!)
                .observeSingleEvent(of: .value) { (dataSnapshot) in

                    if dataSnapshot.hasChildren() == true {
                        for snap in dataSnapshot.children {
                            let userSnap = snap as! DataSnapshot
                            let userDict = userSnap.value as! [String: Any]
                            let messageToUserId = userDict["messageToUserID"] as! String
                            let textMessage = userDict["messageText"] as! String
                            let time = userDict["timestamp"] as! NSNumber
                                
                            if messageToUserId == Auth.auth().currentUser?.uid {
                                if user.messageText == "" {
                                    user.messageText = textMessage
                                } else {
                                    if time.int32Value > user.timestamp!.int32Value {
                                        if textMessage == "" {
                                            user.messageText = "Ty: \(user.messageText!)"
                                        } else {
                                            user.messageText = textMessage
                                        }
                                    } else if time.int32Value < user.timestamp!.int32Value {
                                        user.messageText = "Ty: \(user.messageText!)"
                                    }
                                }
                            }
                        }
                    } else {
                        user.messageText = "Ty: \(user.messageText!)"
                    }
                        
                    self.users.append(user)
                    _ = self.users.sort { (user1, user2) -> Bool in
                        return user1.timestamp!.int32Value > user2.timestamp!.int32Value
                    }
                                                
                    DispatchQueue.main.async {
                        self.userTableView.reloadData()
                    }
                }
            }
        }, withCancel: nil)
    }
}

extension UserViewController : UITableViewDataSource, UITableViewDelegate {
    //MARK: - TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.user = user
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            let vc = ChatViewController()
            vc.uidReceived = self.users[indexPath.row].messageToUserID
            vc.emailReceived = self.users[indexPath.row].userEmail
            vc.nameReceived = self.users[indexPath.row].messageToUser
            vc.titleName = self.users[indexPath.row].messageToUser
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
