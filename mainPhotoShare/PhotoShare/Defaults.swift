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
    
    static var def  = NSUserDefaults.standardUserDefaults()
    static func setValue(value:AnyObject?, forKeyPath: String){
        def.setValue(value, forKeyPath: forKeyPath)
        def.synchronize()
    }
    
    static func value(keyPath: String) -> AnyObject? {
        return def.valueForKeyPath(keyPath)
    }
    static var token : String? {
        get {
        return def.stringForKey("_token")
        }
        set {
            def.setValue(newValue, forKeyPath: "_token")
            def.synchronize()
        }
    }
    static var user : AnyObject? {
        get {
        return def.objectForKey("user")
        }
        set {
            def.setValue(newValue, forKeyPath: "user")
            def.synchronize()
        }
    }
    
    static var email : String? {
        get {
        return def.stringForKey("email")
        }
        set {
            def.setValue(newValue, forKeyPath: "email")
            def.synchronize()
        }
    }
    
    static var password : String? {
        get {
        return def.stringForKey("password")
        }
        set {
            def.setValue(newValue, forKeyPath: "password")
            def.synchronize()
        }
    }
    
    static var login_data : [String: AnyObject]?{
        get {
        return def.dictionaryForKey("login_data") as? [String:String]
        }
        set {
            def.setValue(newValue, forKey: "login_data")
            def.synchronize()
        }
    }
    static var event_data  : AnyObject? {
        get {
        
        return def.valueForKey("event_data")
        }
        set {
            def.setValue(newValue, forKey: "event_data")
            def.synchronize()
        }
    }
    
    static var last_event : AnyObject? {
        get{
        return def.valueForKey("last_event")
        }
        set{
            def.setValue(newValue, forKey: "last_event")
            def.synchronize()
        }
    }
    
    static var last_event_id : String? {
        get {
        return def.stringForKey("event_id")
        }
        set {
            def.setValue(newValue, forKey: "event_id")
            def.synchronize()
        }
    }
}