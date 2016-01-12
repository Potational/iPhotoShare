//
//  LoadQRViewController.swift
//  PhotoShare
//
//  Created by 4423 on 2015/10/09.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit
import AVFoundation

class LoadQRViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QRCODE読み込み"
        // セッションの作成.
        let mySession: AVCaptureSession! = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // デバイスを格納する.
        var myDevice: AVCaptureDevice!
        
        // バックカメラをmyDeviceに格納.
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // バックカメラから入力(Input)を取得.
        let videoInput: AVCaptureInput!
        do {
            videoInput = try AVCaptureDeviceInput.init(device: myDevice!)
        }catch{
            videoInput = nil
        }
        
        mySession.addInput(videoInput)
        // 出力(Output)をMeta情報に.
        let myMetadataOutput: AVCaptureMetadataOutput! = AVCaptureMetadataOutput()
        
        if mySession.canAddOutput(myMetadataOutput) {
            // セッションに追加.
            mySession.addOutput(myMetadataOutput)
            // Meta情報を取得した際のDelegateを設定.
            myMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            // 判定するMeta情報にQRCodeを設定.
            myMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        }
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session:mySession)
        myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
 
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        mySession.startRunning()
    }
    
    var qrRead = false
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        qrRead = false
    }
    
    
    // Meta情報を検出際に呼ばれるdelegate.
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        if qrRead == false && (metadataObjects.count > 0) {
            qrRead = true
            let qrData: AVMetadataMachineReadableCodeObject  = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
//            読み込んだデータの種類
            print("\(qrData.type)")
//            読み込んだ文字データ
            print("QR URL : \(qrData.stringValue)")
        
            let url = qrData.stringValue
            joinLink(url) {
                
                result in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let mainViewController = storyboard.instantiateViewControllerWithIdentifier("CamController")
                let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
                
                let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
                
                rightViewController.mainViewController = nvc
                
                
                
                nvc.setNavigationBarHidden(false, animated: true)
                
                
                self.performSegueWithIdentifier("toCamController",sender: nil)//カメラ画面へ
                
                let soundIdRing:SystemSoundID = 1000
                
                AudioServicesPlaySystemSound(soundIdRing)
                
            }
            
        }
    }
    
    func joinLink(var url:String, done:((AnyObject? )->Void)? = nil) {
        
        url = url + "?mobile=1"
        mgr.request(.GET, url)
        .responseJSON { (res) -> Void in

            print(res.result.value)
            done?(res.result.value)
            
            let j = JSON(res.result.value ?? [])
            Defaults.last_event_id = j["event","id"].stringValue
        }
        .responseString { (res) -> Void in
            print(res)
            
        }
    }
}
