//
//  DateExtension.swift
//  Rss_Reader_Sample
//
//  Created by Yoki on 2017/09/24.
//  Copyright © 2017年 yoki. All rights reserved.
//

import Foundation

extension Date {
    
    static func convertDateFromString (_ dateString:String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        let date: Date! = formatter.date(from: dateString)
        return date
    }
    
    func convertStringFromDate () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyy/MM/dd HH:mm"
        let outputString = formatter.string(from: self)
        return outputString
    }
    
}
