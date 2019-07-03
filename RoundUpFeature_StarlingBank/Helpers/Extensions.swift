//
//  Extensions.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 7/2/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

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

extension UILabel {
    convenience init(text: String, font: UIFont, numberOfLines: Int = 1) {
        self.init(frame: .zero)
        self.text = text
        self.font = font
        self.numberOfLines = numberOfLines
    }
}

extension UIImageView {
    convenience init(cornerRadius: CGFloat) {
        self.init(image: nil)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
    }
}

extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
    }
}
