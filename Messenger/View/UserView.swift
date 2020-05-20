//
//  UserView.swift
//  Messenger
//
//  Created by Maciej Wołejko on 19/05/2020.
//  Copyright © 2020 user161709. All rights reserved.
//

import UIKit

class UserView: UIView {
    
    let screen = UIScreen.main.bounds
    let reuseIdentifier = "reuseCell"
    var users = [User]()
    
    lazy var userTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorColor = .white
        tableView.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        
        [userTableView].forEach { addSubview($0) }
        
        userTableView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: -10, bottom: 0, right: 10), size: .init(width: screen.width, height: 0))
    }
}
