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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++= Section()
            <<< EmailRow("email") {
                $0.title = "Email"
                $0.value = "syaorann200614567@gmail.com"
            }
            <<< PasswordRow("password"){
                $0.title = "Password"
                $0.value = "43215632"
            }
            <<< ButtonRow("submit") {
                $0.title = "LOGIN"
                }.onCellSelection({ [weak self](cell, row) -> () in
                    
                    var login_data = [String:AnyObject]()
                    
                    for (key,val) in (self?.form.values())! {
                        if key == "email" || key == "password" {
                            if val == nil {
                                self?.alert("入力不正です", message: nil)
                                return
                            }
                            login_data[key] = val as? String
                        }
                        
                    }
                    
                    Defaults.login_data = login_data
                    
                    LOGIN_WITH_EMAIL(){user in
                        self?.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                    })
        
        // Do any additional setup after loading the view.
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
