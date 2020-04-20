//
//  ChatCollectionViewCell.swift
//  Messenger
//
//  Created by MW on 12/10/19.
//  Copyright © 2019 MW. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    private lazy var leftCornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var rightCornerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemPink
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let screen = UIScreen.main.bounds
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupObjects()
    }
    
    func setupObjects() {
        [textLabel].forEach { addSubview($0) }
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
