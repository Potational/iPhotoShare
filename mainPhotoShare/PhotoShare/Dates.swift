//
//  Dates.swift
//  PhotoShare
//
//  Created by ZEmac on 2016/01/20.
//  Copyright © 2016年 ie4a. All rights reserved.
//

import Foundation

extension NSDate {
    convenience init(ISO8601:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateStringFormatter.locale = NSLocale.systemLocale()
        let d = dateStringFormatter.dateFromString(ISO8601)
        self.init(timeInterval:0, sinceDate:d!)
    }
    
    class func getLastDayOfMonthFrom(month:Int,year:Int) -> NSDate {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale.systemLocale()
        let d = dateStringFormatter.dateFromString(String(format:"%i-%02d-%@",year,month,"01"))
        let calendar = NSCalendar.currentCalendar()
        let range:NSRange = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: d!)
        let finalDate = dateStringFormatter.dateFromString(String(format:"%i-%02d-%02d",year,month,range.length))
        return finalDate!
    }
    
    class func areDatesSameDay(dateOne:NSDate,dateTwo:NSDate) -> Bool {
        let calender = NSCalendar.currentCalendar()
        let flags: NSCalendarUnit = [.Day, .Month, .Year]
        let compOne: NSDateComponents = calender.components(flags, fromDate: dateOne)
        let compTwo: NSDateComponents = calender.components(flags, fromDate: dateTwo);
        return (compOne.day == compTwo.day && compOne.month == compTwo.month && compOne.year == compTwo.year);
    }
    
    class func isDateExpired(date:NSDate) -> Bool {
        return (date.timeIntervalSinceNow < 0)
    }
    
    class func stringFromDate(date:NSDate) -> String {
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "dd/MM/yyyy"
        let date_string = date_formatter.stringFromDate(date)
        return date_string
    }
    
    class func timeAndDateStringFromDate(date:NSDate) -> String {
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "dd/MM/yyyy  HH:mm"
        let date_string = date_formatter.stringFromDate(date)
        return date_string
    }
    
    class func readableDateStringFromDate(date:NSDate) -> String {
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "EEE d%@ MMM YYYY"
        let date_string = date_formatter.stringFromDate(date)
        return String(format: date_string, date.daySuffix())
    }
    
    class func readableDateTimeStringFromDate(date:NSDate) -> String {
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "HH:mm, EEE d%@ MMM YYYY"
        let date_string = date_formatter.stringFromDate(date)
        return String(format: date_string, date.daySuffix())
    }
    
    class func timeStringFromDate(date:NSDate) -> String {
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "HH:mm"
        let date_string = date_formatter.stringFromDate(date)
        return date_string
    }
    
    class func hoursAndMinutesFromDate(date:NSDate) -> String {
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "HH:mm"
        let date_string = date_formatter.stringFromDate(date)
        return date_string
    }
    
    class func yearMonthDayDateString(date:NSDate) -> String {
        let date_formatter = NSDateFormatter()
        date_formatter.dateFormat = "yyyy-MM-dd"
        let date_string = date_formatter.stringFromDate(date)
        return date_string
    }
    
    func daySuffix() -> String {
        let calendar = NSCalendar.currentCalendar()
        let dayOfMonth = calendar.component(.Day, fromDate: self)
        switch dayOfMonth {
        case 1: fallthrough
        case 21: fallthrough
        case 31: return "st"
        case 2: fallthrough
        case 22: return "nd"
        case 3: fallthrough
        case 23: return "rd"
        default: return "th"
        }
    }
    
    class func daysFrom(date:NSDate,endDate:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: endDate, options: []).day
    }
    
    class func hoursFrom(date:NSDate,endDate:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: endDate, options: []).hour
    }
    
    class func minutesFrom(date:NSDate,endDate:NSDate) -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: endDate, options: []).minute
    }
}