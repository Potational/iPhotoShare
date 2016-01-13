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

var nowViewController : UIViewController?

var mgr: Manager!

var sliceVC : SlideMenuController!

var appDelegate : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    static var noweventid : String?

    var mainVC  : UIViewController?
    
    var cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage()

    func configureManager(){
        let cfg = NSURLSessionConfiguration.defaultSessionConfiguration()
        cfg.HTTPCookieStorage = cookies
        cfg.HTTPAdditionalHeaders = Manager.defaultHTTPHeaders
        
        mgr = Manager(configuration: cfg)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        configureManager()
        
        // Override point for customization after application launch.
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        
        self.mainVC = mainViewController
        
        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
        
        let event_list = EventsTableViewController(nibName: "EventsTableViewController", bundle: nil)
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)


        rightViewController.mainViewController = nvc
        
        nvc.setNavigationBarHidden(false, animated: true)
        
        let slideMenuController = SlideMenuController(mainViewController:nvc, leftMenuViewController: event_list,rightMenuViewController: rightViewController)
        
    
        nowViewController = slideMenuController

        sliceVC = slideMenuController

        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        
        self.window?.rootViewController = slideMenuController
        
        self.window?.makeKeyAndVisible()
      
        return true
    }
    func logout(){
        Alamofire.request(.GET, URL("/auth/logout"))
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

