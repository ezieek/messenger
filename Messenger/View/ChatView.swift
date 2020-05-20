//
//  ChatView.swift
//  Messenger
//
//  Created by Maciej Wołejko on 19/05/2020.
//  Copyright © 2020 user161709. All rights reserved.
//

import UIKit

class ChatView: UIView {

    let screen = UIScreen.main.bounds
    let reuseIdentifier = "reuseCell"
    
    lazy var chatCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    lazy var mainView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var messageTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.backgroundColor = UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1)
        textField.attributedPlaceholder = NSAttributedString(string: "Put your text here", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)])
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.borderColor = CGColor(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Wyslij", for: .normal)
        button.setTitleColor(UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 1), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = CGColor(srgbRed: 0/255, green: 0/255, blue: 0/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("OK", for: .normal)
        button.setTitleColor(UIColor(displayP3Red: 230/255, green: 126/255, blue: 34/255, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSubViews() {
        
        [chatCollectionView, mainView].forEach { addSubview($0) }
        
        chatCollectionView.anchor(top: safeAreaLayoutGuide.topAnchor, leading: leadingAnchor, bottom: mainView.topAnchor, trailing: trailingAnchor, padding: .init(top: 10, left: 10, bottom: 10, right: 10), size: .init(width: screen.width, height: 0))
        
        mainView.anchor(top: chatCollectionView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .zero, size: .init(width: screen.width, height: 100))

        [messageTextField, sendButton].forEach({mainView.addSubview($0)})
        
        messageTextField.anchor(top: mainView.topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: screen.width * 0.01, bottom: 0, right: 0), size: .init(width: screen.width * 0.79, height: screen.height * 0.05))
        
        sendButton.anchor(top: mainView.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: screen.width * 0.01), size: .init(width: screen.width * 0.19, height: screen.height * 0.05))
    }

}
