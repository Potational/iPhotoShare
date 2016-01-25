//
//  QRCameraViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2016/01/13.
//  Copyright © 2016年 ie4a. All rights reserved.
//

import UIKit
import AVFoundation

class QRReaderViewController :UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    //    @IBOutlet weak var messageLabel:UILabel!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    var reading  = true
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reading = true
        qrCodeFrameView?.frame = CGRectZero
        
//        navigationController?.navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "URL", style: .Plain, target: self,action: "URLInput")
//        navigationController?.navigationBar.hidden = false
    }
    
//    func URLInput() {
//        self.dismissViewControllerAnimated(true, completion: nil)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "QRCode"
        
        
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            // Move the message label to the top view
            //            view.bringSubviewToFront(messageLabel)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.greenColor().CGColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRectZero
            //            messageLabel.text = "No barcode/QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if let url = metadataObj.stringValue {
                
                if reading == true  {
                    
                    reading = false
                    
                    self.loadURL(url)
                }
                
            }
        }
    }
    
    var event: JSON!
    func loadURL(url:String){
        
        joinLink(url) {
            
            [weak self] json in
            
            self?.event = json["event"]
            
            print(self?.event)
            
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
//            let mainViewController = storyboard.instantiateViewControllerWithIdentifier("CamController")
//            let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
            
//            let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
            
//            rightViewController.mainViewController = nvc
            
            
            
//            nvc.setNavigationBarHidden(false, animated: true)
            
            //                self.performSegueWithIdentifier("toCamController",sender: nil)//カメラ画面へ
            //                self.performSegueWithIdentifier("qr-pvc", sender: nil)
            
            self?.performSegueWithIdentifier("toMaterialPicker", sender: nil)
            
            //            let soundIdRing:SystemSoundID = 1000
            //
            //            AudioServicesPlaySystemSound(soundIdRing)
            
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMaterialPicker" {
            
            guard event != nil else{
                 return
            }
            
            let picker = segue.destinationViewController as! MaterialPickerViewController
            picker.event = event
        }
    }
    
    //    func joinLink(var url:String, done:((AnyObject? )->Void)? = nil) {
    //
    //        url = url.stringByReplacingOccurrencesOfString("https://photoshare.space", withString: "https://www.photoshare.space")
    //
    //        url = url + "?mobile=1"
    //
    //        print(__FUNCTION__,url)
    //
    //        //822a5ac9-1659-3013-8a14-54e69ddb
    //
    //        mgr.request(.GET, url)
    //            .responseJSON { (res) -> Void in
    //
    //                let j = JSON(res.result.value ?? [])
    //
    //                if j["joined"].boolValue {//joined ok
    //                    Defaults.last_event_id = j["event","id"].stringValue
    //                    print(res.result.value)
    //                    done?(res.result.value)
    //                }else{
    //                    self.alert(j["note"].stringValue, message: nil)
    //                }
    //
    //            }
    //            .responseString { (res) -> Void in
    //                print(res)
    //
    //        }
    //    }
}
