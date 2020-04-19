//
//  UserCollectionViewCell.swift
//  Messenger
//
//  Created by MW on 1/29/20.
//  Copyright © 2020 MW. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    lazy var timeLabel: UILabel = {
        let tl = UILabel()
        tl.font = UIFont.systemFont(ofSize: 13)
        tl.translatesAutoresizingMaskIntoConstraints = false
        return tl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        setupObjects()
        setupColors()
        imageView?.frame = CGRect(origin: CGPoint(x: -10, y: 0), size: CGSize(width: 10, height: 10))
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupObjects() {
        [timeLabel].forEach{addSubview($0)}

        NSLayoutConstraint.activate([
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupColors() {
        backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        textLabel?.textColor = .black
        timeLabel.textColor = .black
        detailTextLabel?.textColor = .black
    }
}
