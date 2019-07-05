//
//  Date.swift
//  RoundUpFeature_StarlingBank
//
//  Created by Muhammad Shahrukh on 7/1/19.
//  Copyright © 2019 Muhammad Shahrukh. All rights reserved.
//

import Foundation

public func timeElapsed(transactionDate: String) -> Int {
    
    let transactionDate = transactionDate
    
    let calendar = Calendar.current
    
    let currentDate = Date()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    
    let secondDate = dateFormatter.date(from: transactionDate) ?? Date()
    
    let date1 = calendar.startOfDay(for: currentDate)
    let date2 = calendar.startOfDay(for: secondDate)
    
    let components = calendar.dateComponents([.day], from: date2, to: date1)
    
    let days = components.day ?? 0
    
    return days
    
}

public func formatDate(date: String) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    
    let dateObj: Date? = dateFormatterGet.date(from: date)
    
    return dateFormatter.string(from: dateObj!)
}

extension Date {
    
    func timeAgoDisplay() -> String {
        
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        let quotient: Int
        let unit: String
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "second"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "min"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "hour"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "week"
        } else {
            quotient = secondsAgo / month
            unit = "month"
        }
        
        return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        
    }
}
