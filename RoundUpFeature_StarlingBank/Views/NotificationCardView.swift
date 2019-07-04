//
//  CardViewController.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 7/4/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

protocol NotificationCardViewDelegate {
    
    func dismissNotificationView()
    
}

class NotificationCardView: UIView {
    
    var delegate: NotificationCardViewDelegate?
    
    lazy var textLabel = UILabel()
    lazy var doneButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 16
        clipsToBounds = true
     
        setupGradientLayer()
        setupTextLabel()
        setupDoneButton()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTextLabel() {
        
        textLabel.text = "Successfully completed the task"
        textLabel.font = UIFont.boldSystemFont(ofSize: 20)
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        addSubview(textLabel)
        textLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    func setupDoneButton() {
        
        doneButton.setTitle("DONE", for: .normal)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        doneButton.backgroundColor    = .white
        doneButton.layer.cornerRadius = 12
        doneButton.alpha = 0.5
        doneButton.addTarget(self, action: #selector(handleDismissCardView), for: .touchUpInside)
        
        addSubview(doneButton)
        doneButton.anchor(top: textLabel.bottomAnchor, leading: nil, bottom: bottomAnchor, trailing: nil, padding: .init(top: 10, left: 0, bottom: 20, right: 0), size: .init(width: 100, height: 50))
        doneButton.centerXInSuperview()
        
    }
    
    @objc func handleDismissCardView() {
        
     self.delegate?.dismissNotificationView()
        
    }
    
    let gradientLayer = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        
    }
    
    fileprivate func setupGradientLayer() {
        
        let topColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        // make sure to user cgColor
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        layer.addSublayer(gradientLayer)
        gradientLayer.frame = bounds
    }

}

