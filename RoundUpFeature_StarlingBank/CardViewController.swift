//
//  CardViewController.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 7/4/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class MyViewController: UIView {
    
    lazy var textLabel      = UILabel()
    lazy var doneButton     = UIButton()
    
    var cardViewBottomConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setupTitleLabel()
        setupWatchButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupTitleLabel() {
        textLabel.text             = "Successfully completed the task"
        textLabel.font             = UIFont.boldSystemFont(ofSize: 20)
        textLabel.textColor        = .darkGray
        textLabel.textAlignment    = .center
        
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
    }
    
    func setupWatchButton() {
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor    = .red
        doneButton.layer.cornerRadius = 12
        
        addSubview(doneButton)
        doneButton.anchor(top: textLabel.bottomAnchor, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .zero, size: .init(width: 100, height: 50))
    }
    

}

