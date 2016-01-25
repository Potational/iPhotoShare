//
//  URL.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/02.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

func URL(add:String = "") -> String {
    return "https://www.photoshare.space/\(add)"
}

func SAVEKEY(key:String,value:AnyObject){
    NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
}
func SETKEY(key:String,value:AnyObject?){
    NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
}
func GETKEY(key:String) -> AnyObject? {
    return NSUserDefaults.standardUserDefaults().valueForKeyPath(key)
}



func isLoggedIn() -> Bool {
    return NSFileManager.defaultManager().fileExistsAtPath(docDir("auth"))
}

func build_data(var data : [String: AnyObject], done: ((all_data: [String: AnyObject])->Void)){
    
    GET_TOKEN(true) { (token) -> Void in
        data["_token"] = token
        data["mobile"] = "1"
        data["remember"] = "1"
        done(all_data: data)
    }
    
}

//func showLoginViewController(){
//
//    dispatch_async(dispatch_get_main_queue()) { () -> Void in
//        //        let v = LoginViewController()
//
//        sliceVC?.presentViewController(loginView, animated: true, completion: nil)
//    }
//
//}

let loginView = {
    mainStoryboard.instantiateViewControllerWithIdentifier("LoginNav")
}()

func GET_TOKEN(refresh:Bool = false, complete: ((token:String) -> Void)? = nil) {
    func refreshTOKEN() {
        mgr.request(.GET,URL("token"))
            .responseString { (res) -> Void in
                
                if let token = res.result.value {
                    
                    SAVEKEY("_token", value: token)
                    
                    Defaults.token = token
                    
                    
                    complete?(token: token )
                    
                    
                }
        }
    }
    if refresh {
        refreshTOKEN()
    }else{
        if let token = GETKEY("_token") {
            if complete != nil{
                complete!(token: token as! String)
            }
        }else{
            refreshTOKEN()
        }
    }
}

//let BASE_URL = "https://www.photoshare.space"
//var GLO_PARAMS : [String:String] = ["mobile":"1"]

enum URL_TYPE : String {
    case LOGIN = "/auth/login"
    case TOKEN = "/token"
    case EVENTS = "/events"
    case PHOTOS = "/events/photos"
    case EVENT_CREATE = "/events/create"
}
func baseUrl(append: URL_TYPE? = nil) -> String {
    var url = URL()
    if append != nil {
        url += append!.rawValue
    }
    return url
}


func goToCamera(event: JSON = nil){
    print(__FUNCTION__)
    
    dispatch_async(dispatch_get_main_queue()) { () -> Void in
        //set picker event
        picker.event = event
        //show picker
        sliceVC.presentViewController(picker, animated: true, completion: nil)
    }
    
}
let picker = {
    UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MaterialPickerViewController") as! MaterialPickerViewController
}()

func joinLink(var event : JSON,done:((JSON )->Void)? = nil) {
    let url  = URL("events/join/?event_id=" + event["id"].stringValue)
    joinLink(url) {
        done_json in
        done?(done_json)
    }
}

func joinLink(var url:String, done:((JSON )->Void)? = nil) {
    
    SwiftNotice.wait([loaderImage!], timeInterval: 0)
    
    if NSUUID(UUIDString: url) != nil {//uuid check
        
        url = URL("events/join/" + url)
        
    }
    
    url = url.stringByReplacingOccurrencesOfString("https://photoshare.space", withString: "https://www.photoshare.space")
    url += "?mobile=1"
    
    print(__FUNCTION__,url)
    
    mgr.request(.GET, url)
        .responseJSON { (res) -> Void in
            
            let j = JSON(res.result.value ?? [])
            
            if j["joined"].boolValue {//joined ok
                
                Defaults.last_event_id = j["event","id"].stringValue
                
                if let event = j["event"].dictionary {
                    
                    for  (k , obj) in event {
                        Defaults.setValue(obj.stringValue, forKeyPath: "event_\(k)")
                    }
                }
                
                
                done?(j)
                
            }else{//joined NG
                sliceVC.alert(j["note"].stringValue, message: nil)
            }
            
            SwiftNotice.clear()
    }
    
}

func refreshEvents(then: (JSON -> Void)? = nil){
    mgr.request(.GET, URL("events"))
        .responseJSON {
            (res) -> Void in
            if let err = res.result.error {
                print(err)
                return
            }
            
            let events = JSON(res.result.value ?? [])
            
            if events != nil {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    writeEventsToLocal(events)
                    write_last_event_json(events[0])
                    then?(events)
                })
            }
            
    }
}
func readLocalEvents() -> JSON {
    let eventsArray = NSData(contentsOfFile: docDir("events.json"))
    if let e = eventsArray {
        return  JSON(data: e)
    }
    return nil
}

func writeEventsToLocal(events : JSON?) {
    if let e = events {
        let eventsData = e.description.dataUsingEncoding(NSUTF8StringEncoding)
        let writeEventsJSON = eventsData?.writeToFile(docDir("events.json"), atomically: false)
        print("writeEventsJSON",writeEventsJSON)
    }
    
}

func write_last_event_json(var event: JSON){
    if event.array != nil && event.array?.count > 0 {
        event = event[0]
    }
    let data = event.description.dataUsingEncoding(NSUTF8StringEncoding)
    let ok = data?.writeToFile(docDir("last_event_json"), atomically: true)
    print(__FUNCTION__, ok)
}
func read_last_event_json() -> JSON {
    print(__FUNCTION__)
    let jData = NSData(contentsOfFile: docDir("last_event_json"))
    if let j = jData {
        return JSON(data: j)
    }
    return nil
}

func docDirSave(fileName:String = "last_event", json: JSON) -> Bool {
    
    let docDir  = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) ).first!
    
    let path = docDir.stringByAppendingString("/" + fileName)
    
    let d = json.description.dataUsingEncoding(NSUTF8StringEncoding)
    
    if let data = d {
        return data.writeToFile(path, atomically: true)
    }
    
    return false
}
func docDir(fileName: String? = nil) -> String {
    let docDir  = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) ).first!
    if fileName == nil {
        return docDir
    }
    let path = docDir.stringByAppendingString("/" + fileName!)
    return path
}

var loaderImage : UIImage? = {
    return UIImage.gifWithName("panda_102"/*"panda_loading"*/)
}()
