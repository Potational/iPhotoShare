//
//  PickerViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2016/01/12.
//  Copyright © 2016年 ie4a. All rights reserved.
//

import UIKit

class PickerViewController: UIImagePickerController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        sourceType = .Camera
        // Do any additional setup after loading the view.
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//        print(image)
        
        saveLocal(image)
        
    }
    
    
    //    写真の保存（ローカルストレージ）
    func saveLocal(getUIImage: UIImage ){
        
        
        let saveFileName = dateFormat(NSDate()) + ".jpeg"
        
        let data : NSData = UIImageJPEGRepresentation(getUIImage, 1.0)!
        
        let documentsDir  = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) ).first!
        
        let dataPath = documentsDir.stringByAppendingString("/" + saveFileName)
        
        let dataURLPath : NSURL = NSURL(fileURLWithPath: dataPath)
        
        data.writeToFile(dataPath, atomically: true)
        
        
        let event_id = Defaults.last_event_id ?? AppDelegate.noweventid
        
        print("event id : \(event_id!)")
        
        GET_TOKEN(true){newtoken in
            print("newtoken:\(newtoken)")
            
            mgr.upload(.POST, URL("photo"),
                
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(fileURL: dataURLPath, name: "userfile[]")
                    
                    let eventid = event_id?.dataUsingEncoding(NSUTF8StringEncoding)
                    
                    multipartFormData.appendBodyPart(data: eventid!,name:"event_id")
                    
                    let gid = "8".dataUsingEncoding(NSUTF8StringEncoding)
                    multipartFormData.appendBodyPart(data: gid!,name:"gid")
                    
                    let mobile = "1".dataUsingEncoding(NSUTF8StringEncoding)
                    multipartFormData.appendBodyPart(data: mobile!,name:"mobile")
                    
                    let token = newtoken.dataUsingEncoding(NSUTF8StringEncoding)
                    multipartFormData.appendBodyPart(data: token!,name:"_token")
                    
                    
                    
                },encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            debugPrint(response)
                        }
                    case .Failure(let encodingError):
                        debugPrint(encodingError)
                    }
            })
        }
        
        //        }
        
        
        
        print("dataPath : \(dataPath)")
        
    }

    func dateFormat(date: NSDate) -> String {
        let df = NSDateFormatter()
        
        df.dateFormat = "YYYYMMddHHmmss"
        
        return df.stringFromDate(date)
        
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
