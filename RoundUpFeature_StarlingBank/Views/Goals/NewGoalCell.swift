//
//  CreateNewGoalsCell.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 7/1/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class NewGoalCell: BaseGoalCell {
    
    override func configureViews() {
        
        goalNameLabel.text = "Create New Goal"
        goalNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        goalImageView.image = UIImage(named: "newGoal.jpg")?.withRenderingMode(.alwaysOriginal)
        

    }
    
    override func setupViews() {

        addSubview(goalImageView)
        addSubview(goalNameLabel)
        goalImageView.fillSuperview()
        goalNameLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 10, right: 0))
    }
   
    
}
