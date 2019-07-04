//
//  RoundUpFunctions.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Sheerien Manzoor on 7/3/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import UIKit

public func convertPoundsCGFloatToMinorUnitsInt(number: CGFloat) -> Int {
    let minorUnitsCGFloat = round(number*100)
    print(minorUnitsCGFloat)
    let minorUnitsInt = Int(minorUnitsCGFloat)
    return minorUnitsInt
}

public func convertMinorUnitsIntToPoundsCGFloat(number: Int) -> CGFloat {
    let pounds = CGFloat(number)/100
    print(pounds)
    return pounds
}

public func convertPoundsStringToMinorUnitsInt(numberInString: String) -> Int {
    let pounds = NumberFormatter().number(from: numberInString) ?? 0
    let minorUnitsCGFloat = CGFloat(truncating: pounds)*100
    let minorUnitsInt = Int(minorUnitsCGFloat)
    return minorUnitsInt
}

public func calculateRoundUpForTransaction(number: Int) -> CGFloat {
    
    let transactionAmountInPounds = convertMinorUnitsIntToPoundsCGFloat(number: number)
    
    if CGFloat(Int(transactionAmountInPounds)) - transactionAmountInPounds != 0 {
        let roundUpAmount = CGFloat(Int(transactionAmountInPounds)) + 1 - transactionAmountInPounds
            return roundUpAmount
    } else {
        return 0
    }
}
