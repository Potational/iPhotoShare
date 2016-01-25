//
//  MaterialPickerViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2016/01/13.
//  Copyright © 2016年 ie4a. All rights reserved.
//

import UIKit
import AVFoundation

class MaterialPickerViewController: UIViewController , CaptureViewDelegate, CaptureSessionDelegate {

   	lazy var captureView: CaptureView = CaptureView()
    lazy var navigationBarView: NavigationBarView = NavigationBarView(frame: CGRectNull)
    lazy var closeButton: FlatButton = FlatButton()
    lazy var cameraButton: FlatButton = FlatButton()
    lazy var videoButton: FlatButton = FlatButton()
    lazy var switchCamerasButton: FlatButton = FlatButton()
    lazy var flashButton: FlatButton = FlatButton()
    lazy var captureButton: FabButton = FabButton()
    
    var event: JSON!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareCaptureButton()
        prepareCameraButton()
//        prepareVideoButton()
        prepareCloseButton()
        prepareSwitchCamerasButton()
        prepareFlashButton()
        prepareCaptureView()
        prepareNavigationBarView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.setTitle(event?["event_name"].string, forState: .Normal)
    }
    /**
     :name:	captureStillImageAsynchronously
     */
    func captureStillImageAsynchronously(capture: CaptureSession, image: UIImage) {
        print("Capture Image \(image)")
        localSaveThenUpload(image)
    }
    
    //    写真の保存（ローカルストレージ）
    func localSaveThenUpload(getUIImage: UIImage ){
        
        let imageSaveFullPath = localSave(getUIImage)
        
        guard imageSaveFullPath != nil else {
            return
        }
        
        let event_id = Defaults.last_event_id //?? AppDelegate.noweventid
        
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
        
        let docDir  = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) ).first!
        
        let saveFullPath = docDir.stringByAppendingString("/" + saveFileName)
        
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
    
    
    /**
     :name:	captureSessionFailedWithError
     */
    func captureSessionFailedWithError(capture: CaptureSession, error: NSError) {
        print(error)
    }
    

    
    /**
     :name:	captureCreateMovieFileFailedWithError
     */
    func captureCreateMovieFileFailedWithError(capture: CaptureSession, error: NSError) {
        print("Capture Failed \(error)")
    }
    
    /**
     :name:	captureDidStartRecordingToOutputFileAtURL
     */
    func captureDidStartRecordingToOutputFileAtURL(capture: CaptureSession, captureOutput: AVCaptureFileOutput, fileURL: NSURL, fromConnections connections: [AnyObject]) {
        print("Capture Started Recording \(fileURL)")
        
        closeButton.hidden = true
        cameraButton.hidden = true
        videoButton.hidden = true
        switchCamerasButton.hidden = true
        flashButton.hidden = true
    }
    
    /**
     :name:	captureDidFinishRecordingToOutputFileAtURL
     */
    func captureDidFinishRecordingToOutputFileAtURL(capture: CaptureSession, captureOutput: AVCaptureFileOutput, outputFileURL: NSURL, fromConnections connections: [AnyObject], error: NSError!) {
        print("Capture Stopped Recording \(outputFileURL)")
        
        closeButton.hidden = false
        cameraButton.hidden = false
        videoButton.hidden = false
        switchCamerasButton.hidden = false
        flashButton.hidden = false
    }
    
    func captureViewDidStartRecordTimer(captureView: CaptureView) {
        navigationBarView.titleLabel!.text = "00:00:00"
        navigationBarView.titleLabel!.hidden = false
        navigationBarView.detailLabel!.hidden = false
    }
    
    /**
     :name:	captureViewDidUpdateRecordTimer
     */
    func captureViewDidUpdateRecordTimer(captureView: CaptureView, hours: Int, minutes: Int, seconds: Int) {
        MaterialAnimation.animationDisabled {
            self.navigationBarView.titleLabel!.text = String(format: "%02i:%02i:%02i", arguments: [hours, minutes, seconds])
        }
    }
    
    /**
     :name:	captureViewDidStopRecordTimer
     */
    func captureViewDidStopRecordTimer(captureView: CaptureView, hours: Int, minutes: Int, seconds: Int) {
        navigationBarView.titleLabel!.hidden = true
        navigationBarView.detailLabel!.hidden = true
    }
    
    /**
     :name:	captureSessionWillSwitchCameras
     */
    func captureSessionWillSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition) {
        // ... do something
    }
    
    /**
     :name:	captureSessionDidSwitchCameras
     */
    func captureSessionDidSwitchCameras(capture: CaptureSession, position: AVCaptureDevicePosition) {
        var img: UIImage?
        if .Back == position {
            captureView.captureSession.flashMode = .Auto
            
            img = UIImage(named: "ic_flash_auto_white")
            flashButton.setImage(img, forState: .Normal)
            flashButton.setImage(img, forState: .Highlighted)
            
            img = UIImage(named: "ic_camera_front_white")
            switchCamerasButton.setImage(img, forState: .Normal)
            switchCamerasButton.setImage(img, forState: .Highlighted)
        } else {
            captureView.captureSession.flashMode = .Off
            
            img = UIImage(named: "ic_flash_off_white")
            flashButton.setImage(img, forState: .Normal)
            flashButton.setImage(img, forState: .Highlighted)
            
            img = UIImage(named: "ic_camera_rear_white")
            switchCamerasButton.setImage(img, forState: .Normal)
            switchCamerasButton.setImage(img, forState: .Highlighted)
        }
    }
    
    /**
     :name:	captureViewDidPressFlashButton
     */
    func captureViewDidPressFlashButton(captureView: CaptureView, button: UIButton) {
        if .Back == captureView.captureSession.cameraPosition {
            var img: UIImage?
            
            switch captureView.captureSession.flashMode {
            case .Off:
                img = UIImage(named: "ic_flash_on_white")
                captureView.captureSession.flashMode = .On
            case .On:
                img = UIImage(named: "ic_flash_auto_white")
                captureView.captureSession.flashMode = .Auto
            case .Auto:
                img = UIImage(named: "ic_flash_off_white")
                captureView.captureSession.flashMode = .Off
            }
            
            button.setImage(img, forState: .Normal)
            button.setImage(img, forState: .Highlighted)
        }
    }
    
    /**
     :name:	captureViewDidPressCameraButton
     */
    func captureViewDidPressCameraButton(captureView: CaptureView, button: UIButton) {
        captureButton.backgroundColor = MaterialColor.blue.darken1.colorWithAlphaComponent(0.3)
        
        performSegueWithIdentifier("toPhotoStream", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toPhotoStream" {
            
            let photosView = (segue.destinationViewController as! UINavigationController).topViewController as! PhotoStreamViewController
            
            photosView.event = event
            photosView.needDoneBarButtonItem = true
//            print(des.event)
        }
    }
    
    /**
     :name:	captureViewDidPressVideoButton
     */
    func captureViewDidPressVideoButton(captureView: CaptureView, button: UIButton) {
        captureButton.backgroundColor = MaterialColor.red.darken1.colorWithAlphaComponent(0.3)
    }
    
    /**
     :name:	captureViewDidPressCaptureButton
     */
    func captureViewDidPressCaptureButton(captureView: CaptureView, button: UIButton) {
        if .Photo == captureView.captureMode {
            // ... do something
        } else if .Video == captureView.captureMode {
            // ... do something
        }
    }
    
    /**
     :name:	captureViewDidPressSwitchCamerasButton
     */
    func captureViewDidPressSwitchCamerasButton(captureView: CaptureView, button: UIButton) {
        // ... do something
    }
    
    /**
     :name:	prepareView
     */
    private func prepareView() {
        view.backgroundColor = MaterialColor.black
    }
    
    /**
     :name:	prepareCaptureView
     */
    private func prepareCaptureView() {
        view.addSubview(captureView)
        captureView.tapToFocusEnabled = true
        captureView.tapToExposeEnabled = true
        captureView.translatesAutoresizingMaskIntoConstraints = false
        captureView.delegate = self
        captureView.captureSession.delegate = self
        MaterialLayout.alignToParent(view, child: captureView)
    }
    
    /**
     :name:	prepareNavigationBarView
     */
    private func prepareNavigationBarView() {
        navigationBarView.backgroundColor = nil
        navigationBarView.depth = .None
        navigationBarView.statusBarStyle = .LightContent
        
        // Title label.
//        let titleLabel: UILabel = UILabel()
//        titleLabel.hidden = false
//        titleLabel.text = Defaults.value("event_name") as? String
//        titleLabel.textAlignment = .Center
//        titleLabel.textColor = MaterialColor.red.accent1
//        titleLabel.font = RobotoFont.regularWithSize(10)
//        navigationBarView.titleLabel = titleLabel
        
        // Detail label.
//        let detailLabel: UILabel = UILabel()
//        detailLabel.hidden = false
//        detailLabel.text = Defaults.value("event_name") as? String
//        detailLabel.textAlignment = .Center
//        detailLabel.textColor = MaterialColor.red.accent1
//        detailLabel.font = RobotoFont.regularWithSize(10)
//        navigationBarView.detailLabel = detailLabel
        
//        let titleButton = FlatButton()
//        titleButton.height = 48
//        titleButton.setTitle(Defaults.value("event_name") as? String, forState: .Normal)
//        titleButton.setTitleColor(MaterialColor.red.accent1, forState: .Normal)
//        titleButton.titleLabel?.font = RobotoFont.regularWithSize(10)
//        titleButton.titleLabel?.textAlignment = .Left
        
        navigationBarView.leftButtons = [closeButton]
        navigationBarView.rightButtons = [switchCamerasButton, flashButton]
        
        view.addSubview(navigationBarView)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navigationBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
        MaterialLayout.height(view, child: navigationBarView, height: 70)
    }
    
    /**
     :name:	prepareCaptureButton
     */
    private func prepareCaptureButton() {
        captureButton.width = 72
        captureButton.height = 72
        captureButton.pulseColor = MaterialColor.white
        captureButton.pulseFill = true
        captureButton.backgroundColor = MaterialColor.blue.darken1.colorWithAlphaComponent(0.3)
        captureButton.borderWidth = .Border2
        captureButton.borderColor = MaterialColor.white
        captureButton.depth = .None
     
//        captureButton.setTitle(Defaults.value("event_name") as? String, forState: .Normal)
        captureView.captureButton = captureButton
    }
    
    /**
     :name:	prepareCameraButton
     */
    private func prepareCameraButton() {
//        let img4: UIImage? = UIImage(named: "ic_photo_camera_white_36pt")
        
        cameraButton.width = 100
        cameraButton.height = 72
//        cameraButton.pulseColor = nil
//        cameraButton.setImage(img4, forState: .Normal)
//        cameraButton.setImage(img4, forState: .Highlighted)
        
        cameraButton.titleLabel?.numberOfLines = 0
        cameraButton.titleLabel?.textAlignment = .Center
        cameraButton.titleLabel?.font = RobotoFont.regularWithSize(10)
        
        cameraButton.setTitle(event?["event_name"].string, forState: .Normal)
        cameraButton.setTitleColor(MaterialColor.green.accent1, forState: .Normal)
        captureView.cameraButton = cameraButton
    }
    
    /**
     :name:	prepareVideoButton
     */
    private func prepareVideoButton() {
        let img5: UIImage? = UIImage(named: "ic_videocam_white_36pt")
        videoButton.width = 72
        videoButton.height = 72
//        videoButton.pulseColor = nil
        videoButton.setImage(img5, forState: .Normal)
        videoButton.setImage(img5, forState: .Highlighted)
        
        captureView.videoButton = videoButton
    }
    
    /**
     :name:	prepareCloseButton
     */
    private func prepareCloseButton() {
        let img: UIImage? = UIImage(named: "ic_close_white")
//        closeButton.pulseColor = nil
        closeButton.setImage(img, forState: .Normal)
        closeButton.setImage(img, forState: .Highlighted)
        closeButton.addTarget(self, action: "closeCamera", forControlEvents: .TouchUpInside)
    }
    func closeCamera(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    /**
     :name:	prepareSwitchCamerasButton
     */
    private func prepareSwitchCamerasButton() {
        let img: UIImage? = UIImage(named: "ic_camera_front_white")
//        switchCamerasButton.pulseColor = nil
        switchCamerasButton.setImage(img, forState: .Normal)
        switchCamerasButton.setImage(img, forState: .Highlighted)
        
        captureView.switchCamerasButton = switchCamerasButton
    }
    
    /**
     :name:	prepareFlashButton
     */
    private func prepareFlashButton() {
        let img: UIImage? = UIImage(named: "ic_flash_auto_white")
        flashButton.pulseColor = nil
        flashButton.setImage(img, forState: .Normal)
        flashButton.setImage(img, forState: .Highlighted)
        
        captureView.captureSession.flashMode = .Auto
        captureView.flashButton = flashButton
    }

}
