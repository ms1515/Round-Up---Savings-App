//
//  File.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Sheerien Manzoor on 7/1/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class BaseGoalCell: UICollectionViewCell {
    
    lazy var goalImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        //iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var goalNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        layer.cornerRadius = 10
        isUserInteractionEnabled = true
        
        configureViews()
        setupViews()
    }
    
    func configureViews() {
        
    }
    
    func setupViews() {
        
        addSubview(goalImageView)
        addSubview(goalNameLabel)
        goalImageView.fillSuperview()
        goalNameLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GoalCell: BaseGoalCell {
    
    var savingGoal: SavingsGoalList? {
        didSet{
            
            guard let goalName = savingGoal?.name else {return}
            //guard let goalImage = savingGoal?.base64EncodedPhoto else {return}
            
            goalNameLabel.text = goalName
            //goalImageView.image = convertBase64ToImage(imageString: goalImage)
        }
    }
    
}
