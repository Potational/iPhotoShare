
//
//  AppDelegate.swift
//  PhotoShare
//
//  Created by ie4a on 2015/09/30.
//  Copyright (c) 2015年 ie4a. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

var mgr: Manager!
var mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
var sliceVC : SlideMenuController!

let appDelegate  = UIApplication.sharedApplication().delegate as! AppDelegate

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        configureManager()
        
        configRootVC()
        
        return true
    }
    func configRootVC() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true;
        if isLoggedIn() {
            let login = jsonFromFile(docDir("login"))
            
            if login != nil {
                LoginViewController.LOGIN_WITH_EMAIL(login["email"].stringValue, password: login["password"].stringValue,
                    done: { [unowned self](user) -> Void in
                        
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            
                            let nvc = mainStoryboard.instantiateInitialViewController()!
                            sliceVC = SlideMenuController(mainViewController:nvc, leftMenuViewController: self.leftEventsTable ,rightMenuViewController: self.settingVC)
                            self.window?.rootViewController = sliceVC
                            self.window?.makeKeyAndVisible()
                            
                        })
                        
                    })
            }
        }
        else{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.window?.rootViewController = loginView
            self.window?.makeKeyAndVisible()
        }
        
    }
    
    
    lazy var leftEventsTable = {
        return mainStoryboard.instantiateViewControllerWithIdentifier("EventsTableViewController") as! EventsTableViewController
    }()
    lazy var settingVC = {
        return mainStoryboard.instantiateViewControllerWithIdentifier("SettingViewController") as! SettingViewController
    }()
    
    func configureManager(){
        let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
        cfg.HTTPShouldSetCookies = true
        cfg.HTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        cfg.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        
        mgr = Manager(configuration: cfg)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

