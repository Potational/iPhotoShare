//
//  SettingViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2016/01/25.
//  Copyright © 2016年 ie4a. All rights reserved.
//

import UIKit
import Eureka
import Alamofire

class SettingViewController: FormViewController {
    
    let fileManager = NSFileManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++= Section("AUTH")
            <<< LabelRow("name"){
                [weak self] in
                $0.title = self?.auth(["user","name"]).string
            }
            <<< LabelRow("email") {
                [weak self] in
                $0.title = self?.auth(["user","email"]).string
            }
            <<< ButtonRow("submit") {
                $0.title = "LOGOUT"
                }
                .cellUpdate({ (cell, row) -> () in
                    cell.textLabel?.textColor = UIColor.redColor()
                })
                .onCellSelection({
                    [weak self](cell, row) -> () in
                    //logout
                    mgr.request(.GET, URL("auth/logout"))
                        .responseData({ (res) -> Void in
                            self?.deleteAllDirFiles()
                            
                            appDelegate.configRootVC()
                        })
                    
                    }
        )
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        form.rowByTag("name")?.title = auth(["user","name"]).string
        form.rowByTag("email")?.title = auth(["user","email"]).string
    }
    func auth(key:[JSONSubscriptType]? = nil) -> JSON {
        
        let auth = docDir("auth")
        
        if fileManager.fileExistsAtPath(auth) {
            //get json data
            let json = JSON(data : NSData(contentsOfFile: auth)!)
            
            if key == nil {
                return json
            }
            return json[key!]
        }else {
            print ("\(auth) not exists")
        }
        return nil
    }
    func deleteAllDirFiles()
    {
        //        let cacheURL = NSURL(fileURLWithPath: docDir())
        let fileManager = NSFileManager.defaultManager()
        let e = fileManager.enumeratorAtPath(docDir())
        
        //        let enumerator = fileManager.enumeratorAtURL(cacheURL, includingPropertiesForKeys: nil, options: NSDirectoryEnumerationOptions.SkipsHiddenFiles, errorHandler: nil)
        while let file = e?.nextObject() as? String {
            try! fileManager.removeItemAtPath(docDir(file))
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
