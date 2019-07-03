//
//  Transactions.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 6/30/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import Foundation

struct Transactions: Codable {
    let feedItems: [FeedItem]
}

struct FeedItem: Codable {
    let feedItemUid, categoryUid: String
    let amount, sourceAmount: Amount
    let direction, updatedAt, transactionTime, settlementTime: String?
    let source: String
    let sourceSubType: String?
    let status, counterPartyType, counterPartyUid, counterPartyName: String?
    let counterPartySubEntityUid, reference, country, spendingCategory: String?
    let counterPartySubEntityName, counterPartySubEntityIdentifier, counterPartySubEntitySubIdentifier: String?
}
