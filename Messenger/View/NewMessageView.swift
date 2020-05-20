//
//  NewMessageView.swift
//  Messenger
//
//  Created by Maciej Wołejko on 19/05/2020.
//  Copyright © 2020 user161709. All rights reserved.
//

import UIKit

class NewMessageView: UIView {

    let reuseIdentifier = "reuseCell"
    let screen = UIScreen.main.bounds
    
    lazy var newUsersTableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        tableView.separatorColor = .white
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        
        [newUsersTableView].forEach { addSubview($0) }
        
        newUsersTableView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, trailing: trailingAnchor, padding: .init(top: 2, left: -10, bottom: 0, right: 10), size: .init(width: screen.width, height: screen.height))
    }
}
