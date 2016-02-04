//
//  LoginViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/03.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit
import Eureka
import Alamofire

class LoginViewController: FormViewController {
    
    var reachability: Reachability!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tryReachability()
        
        title = "PhotoShare"
        
        form +++= Section("LOGIN")
            <<< EmailRow("email") {
                $0.title = "Email"
                $0.value = ""
                }.cellUpdate({ (cell, row) -> () in
                    cell.textField.becomeFirstResponder()
                })
            <<< PasswordRow("password"){
                $0.title = "Password"
                $0.value = ""
            }
            <<< ButtonRow("submit") {
                $0.title = "LOGIN"
                }.onCellSelection({
                    [weak self](cell, row) -> () in
                    
                    var email = ""
                    var password = ""
                    for (key,val) in (self?.form.values())! {
                        if key == "email" || key == "password" {
                            if val == nil {
                                self?.alert("入力不正です", message: nil)
                                return
                            }
                            
                            if key == "email"{
                                email = val as! String
                            }else if key == "password" {
                                password = val as! String
                            }
                        }
                    }
                    
                    LoginViewController.LOGIN_WITH_EMAIL(email, password: password){
                        user in
                        appDelegate.configRootVC()
                    }
                    })
        
        // Do any additional setup after loading the view.
    }
    
    static func LOGIN_WITH_EMAIL(email:String! = nil , password : String! = nil, done: ((user: AnyObject?)-> Void)? = nil){
        
        guard email != nil && password != nil else {
            appDelegate.configRootVC()
            return
        }
        var login_data = ["email": email, "password":password]
        
        GET_TOKEN(true) { (token) -> Void in
            login_data["_token"] = token
            login_data["mobile"] = "1"
            login_data["remember"] = "1"
            
            mgr.request(.POST, URL("auth/login"), parameters : login_data)
                
                .responseJSON {(res) -> Void in
                    
                    if let err = res.result.error {
                        SwiftNotice.showNoticeWithText(NoticeType.error, text: err.localizedDescription, autoClear: true, autoClearTime: 2)
                        return
                    }
                    
                    let user = res.result.value
                    
                    let user_json = JSON(user ?? [])
                    
                    if user_json["login"] != nil && user_json["login"].bool == false {
                        
                        //login failed
                        topVC().alert(user_json["errs"].string)
                        return
                    }
                    
                    user_json.writeTo(docDir("auth"))
                    let writeLoginFile = NSFileManager.defaultManager().createFileAtPath(docDir("login"), contents: login_data.description.dataUsingEncoding(NSUTF8StringEncoding), attributes: nil)
                    print("writeLoginFile",writeLoginFile)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        done?(user: user)
                    })
                    
            }
        }
        
    }
    
    
    func tryReachability() {
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reachabilityChanged:",
            name: ReachabilityChangedNotification,
            object: reachability)
        
        try! reachability.startNotifier()
    }
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        if reachability.isReachable() {
            SwiftNotice.clear()
            if reachability.isReachableViaWiFi() {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
        } else {
            print("Not reachable")
            
            dispatch_async(dispatch_get_main_queue()
                , { () -> Void in
                    SwiftNotice.noticeOnSatusBar("インターネット接続できません。", autoClear: false, autoClearTime: 0)
            })
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
extension JSON {
    func writeTo(path: String) -> Bool? {
        return self.description.dataUsingEncoding(NSUTF8StringEncoding)?.writeToFile(path, atomically: true)
    }
}
func topVC() -> UIViewController {
    let top = UIApplication.sharedApplication().keyWindow?.rootViewController
    guard var topVC = top else {
        return UIViewController()
    }
    while let vc = topVC.presentedViewController {
        topVC = vc
    }
    return topVC
}
//extension UIViewController {
//    func topVC() -> UIViewController {
//        let top = UIApplication.sharedApplication().keyWindow?.rootViewController
//        guard var topVC = top else {
//            return UIViewController()
//        }
//        while let vc = topVC.presentedViewController {
//            topVC = vc
//        }
//        return topVC
//    }
//}
