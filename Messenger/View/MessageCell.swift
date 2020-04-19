//
//  ChatCollectionViewCell.swift
//  Messenger
//
//  Created by MW on 12/10/19.
//  Copyright © 2019 MW. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    lazy var textLabel : UILabel = {
        let tl = UILabel()
        tl.backgroundColor = .clear
        tl.textColor = .white
        tl.layer.cornerRadius = 10
        tl.layer.masksToBounds = true
        tl.numberOfLines = 0
        tl.translatesAutoresizingMaskIntoConstraints = false
        return tl
    }()
    
    private lazy var leftCornerView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .systemPink
        cv.layer.cornerRadius = 15
        cv.layer.masksToBounds = true
        return cv
    }()
    
    private lazy var rightCornerView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .systemPink
        cv.layer.cornerRadius = 15
        cv.layer.masksToBounds = true
        return cv
    }()
    
    let screen = UIScreen.main.bounds
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupObjects()
    }
    
    func setupObjects() {
        
        [textLabel].forEach{addSubview($0)}
        
        NSLayoutConstraint.activate([
            textLabel.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
