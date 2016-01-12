//
//  PickerViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2016/01/12.
//  Copyright © 2016年 ie4a. All rights reserved.
//

import UIKit


class PickerViewController: UIImagePickerController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var CaptureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CaptureButtonSetting()
        
        sourceType = .Camera
        
        //        cameraOverlayView = ov_view
        cameraOverlayView = CaptureButton
        showsCameraControls = false
        
        self.delegate = self
        
    }
    
    func CaptureButtonSetting() {
        CaptureButton.origin =
            CGPoint(x : (self.view.frame.size.width - CaptureButton.frame.size.width)/2, y: self.view.frame.size.height - CaptureButton.frame.size.height)
        
        
    }
    lazy var ov_view : UIView = {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.backgroundColor = UIColor.redColor()
        btn.size = CGSize(width: 100, height: 200)
        btn.origin = CGPoint(x:self.view.frame.size.width - 100,y:self.view.frame.size.height - 100)
        btn.setTitle("Test", forState: .Normal)
        return btn
    }()
    
    @IBAction func capture(sender: UIButton) {
        self.takePicture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    //
    //        self.saveLocal(image)
    //        self.dismissViewControllerAnimated(true, completion: nil)
    //
    //    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        saveLocal(img)
        
    }
    
    
    //    写真の保存（ローカルストレージ）
    func saveLocal(getUIImage: UIImage ){
        
        let imageSaveFullPath = localSave(getUIImage)
        
        guard imageSaveFullPath != nil else {
            return
        }
        
        let event_id = Defaults.last_event_id ?? AppDelegate.noweventid
        
        print("event id : \(event_id!)")
        
        GET_TOKEN(true){newtoken in
            
            print("newtoken:\(newtoken)")
            
            mgr.upload(.POST, URL("photo"),
                multipartFormData: { multipartFormData in
                    
                    let dataURLPath : NSURL = NSURL(fileURLWithPath: imageSaveFullPath!)
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
        
        
        
        print("imageSaveFullPath : \(imageSaveFullPath)")
        
    }
    
    func localSave(img:UIImage) -> String? {
        
        let saveFileName = dateFormat(NSDate()) + ".jpeg"
        
        let data : NSData? = UIImageJPEGRepresentation(img, 0.5)
        
        let documentsDir  = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) ).first!
        
        let saveFullPath = documentsDir.stringByAppendingString("/" + saveFileName)
        
        let write_ok = data?.writeToFile(saveFullPath, atomically: true)
        if (write_ok != nil) && (write_ok != false) {
            return saveFullPath
        }
        return nil;
        
    }
    
    func dateFormat(date: NSDate) -> String {
        let df = NSDateFormatter()
        
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
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
