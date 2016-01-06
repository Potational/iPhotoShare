//
//  Date+LVT.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/02.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    static var Date : NSDateFormatter {
        let df = NSDateFormatter()
        df.locale = .currentLocale()
        df.dateStyle = .ShortStyle
        df.timeStyle = .NoStyle
        df.dateFormat = "YYY-MM-dd"
        return df
    }
    static var Time : NSDateFormatter {
        let df = NSDateFormatter()
        df.locale = .currentLocale()
        df.dateStyle = .NoStyle
        df.timeStyle = .ShortStyle
        df.dateFormat = "HH:mm"
        return df

    }
    
    static var DateAndTime : NSDateFormatter {
        let df = NSDateFormatter()
        df.locale = .currentLocale()
        df.dateStyle = .ShortStyle
        df.timeStyle = .ShortStyle
        df.dateFormat = "YYYY-MM-dd HH:mm"
        return df
    }
    
    static var sqlDateTime : NSDateFormatter {
        let df = NSDateFormatter()
        df.locale = .currentLocale()
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return df
    }
}