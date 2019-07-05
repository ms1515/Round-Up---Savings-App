//
//  RefreshToken.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Sheerien Manzoor on 7/5/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import Foundation

struct RefreshToken: Codable {
    let accessToken, refreshToken, tokenType: String
    let expiresIn: Int
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
        case scope
    }
}
