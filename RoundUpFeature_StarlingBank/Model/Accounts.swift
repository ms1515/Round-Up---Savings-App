//
//  Models.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/27/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

struct UserAccount: Codable {
    
    let accounts: [UserDetails]

}

struct UserDetails: Codable {
    
    let accountUid: String
    let defaultCategory: String
    let currency: String
    let createdAt: String
    
}

struct AccountDetails: Codable {

    let accountIdentifier: String
    let bankIdentifier: String
    let iban: String
    let bic: String
    
}

struct Balance: Codable {
    let clearedBalance, effectiveBalance, pendingTransactions, availableToSpend: Amount
    let acceptedOverdraft, amount: Amount
}

struct Amount: Codable {
    let currency: String
    let minorUnits: Int
}
