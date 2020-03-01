//
//  ChatCollectionViewCell.swift
//  Messenger
//
//  Created by MW on 12/10/19.
//  Copyright © 2019 MW. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    var message: Message? {
        didSet {
            
            backgroundColor = .clear
            textLabel1.text = message?.messageText
            textLabel1.textColor = .white
             
            }
    }
    
    lazy var textLabel1 : UILabel = {
        let tl = UILabel()
        tl.backgroundColor = .clear
        tl.textColor = .black
        tl.layer.cornerRadius = 10
        tl.layer.masksToBounds = true
        tl.numberOfLines = 0
        tl.translatesAutoresizingMaskIntoConstraints = false
        return tl
    }()
    
    lazy var leftCornerView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .systemPink
        cv.layer.cornerRadius = 15
        cv.layer.masksToBounds = true
        return cv
    }()
    
    lazy var rightCornerView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .systemPink
        cv.layer.cornerRadius = 15
        cv.layer.masksToBounds = true
        return cv
    }()
    
    let screen = UIScreen.main.bounds
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupObjects()
    }
    
    func setupObjects() {
        
        [textLabel1].forEach({addSubview($0)})
        
        NSLayoutConstraint.activate([
            textLabel1.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor),
            textLabel1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textLabel1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
