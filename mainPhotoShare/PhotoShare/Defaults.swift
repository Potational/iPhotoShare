//
//  Defaults.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/02.
//  Copyright © 2015年 ZEmac. All rights reserved.
//

import Foundation
import UIKit

class Defaults {
    static var token : String? {
        get {
        return NSUserDefaults.standardUserDefaults().stringForKey("_token")
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKeyPath: "_token")
        }
    }
    static var user : AnyObject? {
        get {
        return NSUserDefaults.standardUserDefaults().objectForKey("user")
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKeyPath: "user")
        }
    }
    
    static var email : String? {
        get {
        return NSUserDefaults.standardUserDefaults().stringForKey("email")
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKeyPath: "email")
        }
    }
    
    static var password : String? {
        get {
        return NSUserDefaults.standardUserDefaults().stringForKey("password")
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKeyPath: "password")
        }
    }
    
    static var login_data : [String: AnyObject]?{
        get {
        return NSUserDefaults.standardUserDefaults().dictionaryForKey("login_data") as? [String:String]
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "login_data")
        }
    }
    static var event_data  : AnyObject? {
        get {
        
        //        return NSKeyedUnarchiver.unarchiveObjectWithData(NSUserDefaults.standardUserDefaults().dataForKey("event_data")!)
        return NSUserDefaults.standardUserDefaults().valueForKey("event_data")
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "event_data")
        }
    }
    
    static var last_event_id : String? {
        get {
        return NSUserDefaults.standardUserDefaults().stringForKey("event_id")
        }
        set {
            NSUserDefaults.standardUserDefaults().setValue(newValue, forKey: "event_id")
        }
    }
}