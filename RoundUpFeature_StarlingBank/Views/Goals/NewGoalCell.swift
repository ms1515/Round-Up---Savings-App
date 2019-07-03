//
//  CreateNewGoalsCell.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Sheerien Manzoor on 7/1/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

class NewGoalCell: BaseGoalCell {
    
    override func configureViews() {
        goalNameLabel.text = "Create New Goal"
        goalNameLabel.sizeToFit()
        
        goalImageView.image = UIImage(named: "createNewGoal.png")?.withRenderingMode(.alwaysOriginal)

    }
    
   
    
}
