//
//  JSONExtension.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Sheerien Manzoor on 7/3/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import Foundation

enum MyError: Error {
    
    case encodingError
    
}

extension Encodable {
    
    func toJson() throws -> Data? {
        
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard let json = jsonObject as? Data else {throw MyError.encodingError}
        
        return json
    }
}
