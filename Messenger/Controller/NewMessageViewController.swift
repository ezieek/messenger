//
//  SearchViewController.swift
//  Messenger
//
//  Created by MW on 1/15/20.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "reuseCell"

class NewMessageViewController: UIViewController {

    var users: [User] = []
    let screen = UIScreen.main.bounds
    var userViewController: UserViewController?
    var userNameUsed: [String] = Array()
    var userName: [String] = []
    let initObjects = NewMessageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        setupNavBar()
        initObjects.newUsersTableView.delegate = self
        initObjects.newUsersTableView.dataSource = self
        fetchingEveryRegisteredUsers()
    }
    
    override func loadView() {
        super.loadView()
        
        view = initObjects
    }
    
    func setupNavBar() {
        
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)]
        navigationItem.title = "New Message"
        
        let doneButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(doneButtonPressed))
        doneButton.tintColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        navigationItem.leftBarButtonItem = doneButton
    }
    
    func fetchingEveryRegisteredUsers() {
        
        Database.database().reference().child("users").child("allRegisteredUsers").queryOrdered(byChild: "date").observe(.childAdded) { (snapshot) in
            
                if let dictionary = snapshot.value as? [String: AnyObject] {
                var user = User()
                user.userName = dictionary["myName"] as? String
                user.userEmail = dictionary["myEmail"] as? String
                user.userID = dictionary["myUid"] as? String
              
                if user.userID != Auth.auth().currentUser?.uid {
                    self.users.append(user)
                    DispatchQueue.main.async {
                        self.initObjects.newUsersTableView.reloadData()
                    }
                }
            }
        }
    }

    @objc func doneButtonPressed() {
        navigationController?.pushViewController(UserViewController(), animated: true)
    }
}

extension NewMessageViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = initObjects.newUsersTableView.dequeueReusableCell(withIdentifier: initObjects.reuseIdentifier, for: indexPath) as? UserCell else { return UITableViewCell() }
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.userName
        cell.detailTextLabel!.text = user.userEmail
        cell.imageView!.image = UIImage(named: "user")
        return cell
    }
}
    
extension NewMessageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        DispatchQueue.main.async {
            let names = self.users[indexPath.row].userName
            let email = self.users[indexPath.row].userEmail
            let userUid = self.users[indexPath.row].userID
            
            let values: [String: Any?] =
                ["messageFromUser": Auth.auth().currentUser?.displayName,
                "userEmail": Auth.auth().currentUser?.email,
                "messageToUser": names,
                "messageToUserID": userUid,
                "userID": Auth.auth().currentUser?.uid,
                "timestamp": Int(Date().timeIntervalSince1970),
                "messageText": "",
                "addedUserEmail": email]
            
            let key = Database.database().reference().child("savedFriends").childByAutoId().key
       
            Database.database().reference().child("users").child("savedFriends").child((Auth.auth().currentUser?.displayName)!)
                .queryOrdered(byChild: "messageToUser")
                .queryEqual(toValue: names)
                .observeSingleEvent(of: .value) { (snapshot) in
                    if snapshot.hasChildren() == true {
                        for snap in snapshot.children {
                            let userSnap = snap as? DataSnapshot
                            let userDict = userSnap?.value as? [String: Any]
                            let idAddedUser = userDict?["messageToUserID"] as? String
                            if idAddedUser != userUid {
                                Database.database().reference().child("users").child("savedFriends")
                                    .child(Auth.auth().currentUser!.displayName!)
                                    .child(key!).setValue(values)
                            }
                        }
                    } else {
                        Database.database().reference().child("users").child("savedFriends")
                            .child(Auth.auth().currentUser!.displayName!)
                            .child(key!).setValue(values)
                    }
            }
            
            let chatViewController = ChatViewController()
            chatViewController.titleName = names
            chatViewController.nameReceived = names
            chatViewController.uidReceived = userUid
            chatViewController.emailReceived = email
            
            self.navigationController?.pushViewController(chatViewController, animated: true)
        }
    }
}
