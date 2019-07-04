//
//  File.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 7/1/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

public func convertImageToBase64(image: UIImage) -> String {
    let imageData = image.jpegData(compressionQuality: 0.4) ?? Data()
    return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
}
    
public func convertBase64ToImage(imageString: String) -> UIImage {
    let imageData = Data(base64Encoded: imageString,
                         options: Data.Base64DecodingOptions.ignoreUnknownCharacters) ?? Data()
    return UIImage(data: imageData) ?? UIImage()
}



