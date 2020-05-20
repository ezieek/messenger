//
//  UserViewController.swift
//  Messenger
//
//  Created by MW on 13/01/2020.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController {
    
    var users = [User]()
    let screen = UIScreen.main.bounds
    var loginViewController = LoginViewController()
    var userNameUsed: [String] = Array()
    let initObjects = UserView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        setupNavBar()
        initObjects.userTableView.delegate = self
        initObjects.userTableView.dataSource = self
        fetchingOnlySavedFriends()
    }
    
    override func loadView() {
        super.loadView()
        
        view = initObjects
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
    
    @objc func newMessageButtonPressed() {
        let view = NewMessageViewController()
        view.userNameUsed = userNameUsed
        view.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(view, animated: true)
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
                            let userSnap = snap as? DataSnapshot
                            let userDict = userSnap?.value as? [String: Any?]
                            let messageToUserId = userDict?["messageToUserID"] as? String
                            let textMessage = userDict?["messageText"] as? String
                            let time = userDict?["timestamp"] as? NSNumber
                                
                            if messageToUserId == Auth.auth().currentUser?.uid {
                                if user.messageText == "" {
                                    user.messageText = textMessage
                                } else {
                                    if time?.int32Value ?? 0 > user.timestamp!.int32Value {
                                        if textMessage == "" {
                                            user.messageText = "Ty: \(user.messageText!)"
                                        } else {
                                            user.messageText = textMessage
                                        }
                                    } else if time?.int32Value ?? 0 < user.timestamp!.int32Value {
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
                        self.initObjects.userTableView.reloadData()
                    }
                }
            }
        }, withCancel: nil)
    }
}

extension UserViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = initObjects.userTableView.dequeueReusableCell(withIdentifier: initObjects.reuseIdentifier, for: indexPath) as? UserCell else { return UITableViewCell() }
    
        let user = users[indexPath.row]
        cell.textLabel?.text = user.messageToUser
        cell.imageView!.image = UIImage(named: "user")
        cell.imageView?.frame = CGRect(origin: CGPoint(x: -10, y: 0), size: CGSize(width: 10, height: 10))
        cell.selectionStyle = .none
        
        if let user = user.messageText {
            cell.detailTextLabel!.text = user
        }
        
        if let seconds = user.timestamp?.doubleValue {
            let timestampDate = NSDate(timeIntervalSince1970: seconds)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            cell.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
        }
        
        return cell
    }
}

extension UserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let view = ChatViewController()
            view.uidReceived = self.users[indexPath.row].messageToUserID
            view.emailReceived = self.users[indexPath.row].userEmail
            view.nameReceived = self.users[indexPath.row].messageToUser
            view.titleName = self.users[indexPath.row].messageToUser
            self.navigationController?.pushViewController(view, animated: true)
        }
    }
}
