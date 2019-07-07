//
//  Goals.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 7/1/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import Foundation

struct Goals: Codable {
    let savingsGoalList: [SavingsGoalList]
}

struct SavingsGoalList: Codable {
    let savingsGoalUid, name: String
    let target, totalSaved: Amount
    let savedPercentage: Int?
}

struct SavingsGoalPhoto: Codable {
    let base64EncodedPhoto: String
}

struct FundTransfer: Codable {
    let amount: Amount
}

struct NewGoal: Codable {
    
    let name, currency: String
    let target: Target
    let base64EncodedPhoto: String
}

struct Target: Codable {
    let currency: String
    let minorUnits: Int
}



