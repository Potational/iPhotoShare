//
//  CamController.swift
//  PhotoShare
//
//  Created by ie4a on 2015/09/30.
//  Copyright (c) 2015年 ie4a. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData
import Alamofire

class CamController: UIViewController ,AVCaptureVideoDataOutputSampleBufferDelegate{
    
    
    func dateformat(date:NSDate) -> String {
        let df = NSDateFormatter()
        df.dateFormat = "yyyyMMddHHmmss"
        return df.stringFromDate(date)
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    private var myScrollView: UIScrollView!
    var tick :Float = 0
    var fbflug :Float = 0
    var recognition :Bool = false
    var sampleDrawing : UIView = UIView(frame: CGRectMake( 0, 0, 80, 80))
    var slider: UISlider!
    var gammaslider : UISlider!
    var contrastslider : UISlider!
    
    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    //出力先
    var myOutput : AVCaptureVideoDataOutput!
    // 画像のアウトプット.
    var myImageOutput : AVCaptureStillImageOutput!
    //    ビューがロードされた時
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myBarButton_1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit,target:self ,action: "onClickBarButton:")
        let myBarButton_2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Camera, target: self, action: "onClickBarInButton:")
        let myBarButton_3 = UIBarButtonItem(image: UIImage(named: "OnFlash.png"), style: UIBarButtonItemStyle.Done, target: self, action: "onClickBarFlashButton:")
        //        let myBarButton_4 = UIBarButtonItem(title: "Color", style: UIBarButtonItemStyle.Bordered, target: self, action: "onchangeColor:")
        let myRightButtons : NSArray = [myBarButton_1, myBarButton_2,myBarButton_3]
        self.navigationItem
        self.navigationItem.setRightBarButtonItems(myRightButtons as? [UIBarButtonItem], animated: true)
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        
        
        
        
        // バックカメラをmyDeviceに格納.
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
                fbflug = 0
            }
            
            
            
        }
        
        camsetting()
    }
    //タッチされた時のフォーカス露出動作
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        sampleDrawing.removeFromSuperview()
        
        
        let touchPoint = touches.first! as UITouch
        let screenSize = UIScreen.mainScreen().bounds.size
        let focus_x = touchPoint.locationInView(self.view).x / screenSize.width
        let focus_y = touchPoint.locationInView(self.view).y / screenSize.height
        
        let focusPoint = CGPoint(x: focus_y, y: 1.0 - focus_x )
        if let device = myDevice {
            
            do{
                try device.lockForConfiguration()
            }catch{
                return
            }
            
            if device.focusPointOfInterestSupported {
                touchpoint(touchPoint.locationInView(self.view).x, y: touchPoint.locationInView(self.view).y)
                
                device.focusPointOfInterest = focusPoint
                device.focusMode = AVCaptureFocusMode.AutoFocus
                
            }
            if device.exposurePointOfInterestSupported {
                device.exposurePointOfInterest = focusPoint
                device.exposureMode = AVCaptureExposureMode.AutoExpose
            }
            device.unlockForConfiguration()
            
            
            
        }
        
    }
    
    //    タッチされたところに枠表示
    func touchpoint(x:CGFloat,y:CGFloat ){
        sampleDrawing = UIView(frame: CGRectMake( x - 40, y - 40, 80, 80))
        sampleDrawing.layer.borderWidth = 5
        sampleDrawing.layer.borderWidth = 2
        sampleDrawing.layer.borderColor = UIColor.orangeColor().CGColor
        self.view.addSubview(sampleDrawing)
        
        slider.hidden = true
    }
    
    
    // ラベル作成 サイズを指定して初期化
    let myLabel: UILabel = UILabel(frame: CGRectMake(0,0,171,21))
    
    //    カメラの呼び出し設定
    func camsetting(){
        
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // バックカメラからVideoInputを取得.
        let videoInput: AVCaptureInput!
        do {
            videoInput = try AVCaptureDeviceInput.init(device: myDevice!)
        }catch{
            videoInput = nil
        }
        
        // セッションに追加.
        mySession.addInput(videoInput)
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        //        一番最近消したところ
        //        myVideoLayer = AVCaptureVideoPreviewLayer.init(session:mySession)
        //        myVideoLayer.frame = self.view.bounds
        //        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        //
        // Viewに追加.
        //        self.view.layer.addSublayer(myVideoLayer)
        
        // 出力(Output)をBuffer情報に.
        myOutput = AVCaptureVideoDataOutput()
        myOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA) ]
        
        // FPSを設定
        do {
            try myDevice.lockForConfiguration()
            
            myDevice.activeVideoMinFrameDuration = CMTimeMake(1, 20)
            myDevice.unlockForConfiguration()
        } catch let error {
            print("lock error: \(error)")
            return
        }
        
        myOutput.alwaysDiscardsLateVideoFrames = true
        
        if mySession.canAddOutput(myOutput) {
            let queue : dispatch_queue_t = dispatch_queue_create("myqueue", nil)
            // Meta情報を取得した際のDelegateを設定.
            myOutput.setSampleBufferDelegate(self, queue: queue)
            // セッションに追加.
            mySession.addOutput(myOutput)
        }
        
        
        for connection in myOutput.connections {
            if let conn = connection as? AVCaptureConnection {
                if conn.supportsVideoOrientation {
                    conn.videoOrientation = AVCaptureVideoOrientation.Portrait
                }
            }
        }
        
        
        
        
        // セッション開始.
        mySession.startRunning()
        
        // 撮影ボタンを作成.
        let myButton = UIButton(frame: CGRectMake(0,0,60,60))
        myButton.backgroundColor = UIColor.redColor()
        myButton.layer.masksToBounds = true
        myButton.setTitle("", forState: .Normal)
        myButton.layer.cornerRadius = 60 / 2.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        // UIボタンをViewに追加.
        self.view.addSubview(myButton)
        
      
        
        // Sliderを作成する.
        
        slider = UISlider(frame: CGRectMake(0, 0, self.view.frame.width * 0.9, 20))
        slider.layer.position = CGPointMake(self.view.frame.width / 2, self.view.frame.height - 100)
        slider.layer.cornerRadius = 10.0
        slider.layer.masksToBounds = false
        slider.minimumValue = 1.0
        slider.maximumValue = 5.0
        slider.hidden = true
        slider.value = 1.0
        //          色調補正未実装分
        //        gammaslider = UISlider(frame: CGRectMake(0, 0, self.view.frame.width * 0.9, 20))
        //        gammaslider.layer.position = CGPointMake(self.view.frame.width / 2, 100)
        //        gammaslider.layer.cornerRadius = 10.0
        //        gammaslider.layer.masksToBounds = false
        //        gammaslider.minimumValue = 1.0
        //        gammaslider.maximumValue = 5.0
        //        gammaslider.hidden = true
        //        gammaslider.value = 1.0
        //
        //        contrastslider = UISlider(frame: CGRectMake(0, 0, self.view.frame.width * 0.9, 20))
        //        contrastslider.layer.position = CGPointMake(self.view.frame.width / 2, 130)
        //        contrastslider.layer.cornerRadius = 10.0
        //        contrastslider.layer.masksToBounds = false
        //        contrastslider.minimumValue = 1.0
        //        contrastslider.maximumValue = 5.0
        //        contrastslider.hidden = true
        //        contrastslider.value = 1.0
        
        // 値が変化した時
        slider.addTarget(self, action: "onChangeValueSlider:", forControlEvents: UIControlEvents.ValueChanged)
        //        gammaslider.addTarget(self, action: "onColorChangeValueSlider:", forControlEvents: UIControlEvents.ValueChanged)
        //        contrastslider.addTarget(self, action: "onColorChangeValueSlider:", forControlEvents: UIControlEvents.ValueChanged)
        //
        // 指を離した時
        slider.addTarget(self, action: "ChangeValueEnd:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //        self.view.addSubview(contrastslider)
        //        self.view.addSubview(gammaslider)
        self.view.addSubview(slider)
        
        let pinchin:UIPinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: "pinchinGesture:")
        self.view.addGestureRecognizer(pinchin)
        
        
        
        //            保存メッセージ設定
        self.myLabel.layer.position = CGPoint(x: self.view.bounds.width/2,y: 550)// 位置
        self.myLabel.backgroundColor = UIColor.darkGrayColor()// 背景色
        self.myLabel.hidden = true//非表示
        self.myLabel.text = "写真を保存しました。"// 文字
        self.myLabel.font = UIFont.systemFontOfSize(17)// フォントサイズ
        self.myLabel.textColor = UIColor.whiteColor()// 文字色
        self.myLabel.textAlignment = NSTextAlignment.Center// 文字を中央寄せ
        self.myLabel.layer.masksToBounds = true// 角丸
        self.myLabel.layer.cornerRadius =  10.0// コーナーの半径
        
        // Viewにラベルを追加
        self.view.addSubview(self.myLabel)
        
        
        //        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("onUpdateFlame:"), userInfo: nil, repeats: true)
        
    }
    //    ピンチインジェスチャー
    func pinchinGesture(sender: UIPinchGestureRecognizer){
        slider.hidden = false
        
        print("scale \(sender.scale)")
        
        if let device = myDevice {
            
            do{
                try device.lockForConfiguration()
            }catch{
                return
            }
            
            if sender.scale > 1{
                if device.videoZoomFactor + 0.05 < 5{
                    device.videoZoomFactor += 0.05
                }
                
            }else{
                if device.videoZoomFactor - 0.05 > 1{
                    device.videoZoomFactor -= 0.05
                }
            }
            
            slider.value = Float(device.videoZoomFactor)
            
            print("Factor \(device.videoZoomFactor)")
            
            device.unlockForConfiguration()
            
            
            
        }
        
        
    }
    //    スライダー処理
    func onChangeValueSlider(sender : UISlider){
        
        if let device = myDevice {
            
            do{
                try device.lockForConfiguration()
            }catch{
                return
            }
            
            device.videoZoomFactor = CGFloat(sender.value)
            
            device.unlockForConfiguration()
            
            
            
        }
    }
    func ChangeValueEnd(sender: UISlider){
        slider.hidden = true
    }
    
    
    // シャッターボタンイベント
    func onClickMyButton(sender: UIButton){
        
        // ビデオ出力に接続.
        let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
        
        // 接続から画像を取得.
        self.myImageOutput.captureStillImageAsynchronouslyFromConnection(myVideoConnection, completionHandler: { (imageDataBuffer, error) -> Void in
            
            // 取得したImageのDataBufferをJpegに変換.
            let myImageData : NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
            
            // JpegからUIImageを作成.
            let myUIImage : UIImage = UIImage(data: myImageData)!
            self.saveLocal(myUIImage,jpeg: myImageData)
            
            
            // アルバムに追加.
            UIImageWriteToSavedPhotosAlbum(myUIImage, self, nil, nil)
            self.myLabel.text = "写真を保存しました!"
            self.myLabel.hidden = false //表示
            //            タイマー開始
            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("onUpdate:"), userInfo: nil, repeats: true)
            
            
        })
    }
    
    
    //    写真の保存（ローカルストレージ）
    func saveLocal(getUIImage: UIImage , jpeg:NSData){
        
        
        let now = NSDate()
        
        let data : NSData = UIImageJPEGRepresentation(getUIImage, 1.0)!
        
        let dataPath  = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) ).first!.stringByAppendingString("/\(dateformat(now)).jpeg")
        
        let dataURLPath : NSURL = NSURL(fileURLWithPath: dataPath)
        
        data.writeToFile(dataPath, atomically: true)
    
        
        let event_id = Defaults.last_event_id ?? AppDelegate.noweventid
        
        print("event id : \(event_id!)")
        
        GET_TOKEN(true){newtoken in
            
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
    
    
    
    //    タイマー
    func onUpdate(timer: NSTimer) {
        tick += 0.1
        
        if tick == 0.3{
            //            メッセージ非表示
            self.myLabel.hidden = true
            tick = 0
            //timerを破棄する.
            timer.invalidate()
        }
        
    }
    //    ナビゲーションバーMenuボタン
    func onClickBarButton(sender: UIButton){
        print("onClickBarButton")
        SlideMenuOptions.leftViewWidth = 50
        SlideMenuOptions.contentViewScale = 0.90
        self.slideMenuController()?.openRight()
    }
    //    カメラの前後入れ替え
    func onClickBarInButton(sender: UIButton){
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        if fbflug == 0 {
            // フロントカメラをmyDeviceに格納.
            for device in devices{
                if(device.position == AVCaptureDevicePosition.Front){
                    myDevice = device as! AVCaptureDevice
                    fbflug = 1
                }
            }
            
        }else{
            // バックカメラをmyDeviceに格納.
            for device in devices{
                if(device.position == AVCaptureDevicePosition.Back){
                    myDevice = device as! AVCaptureDevice
                    fbflug = 0
                }
            }
            
        }
        camsetting()
    }
    //    フラッシュON/OFF
    func onClickBarFlashButton(sender:UIButton){
        if let device = myDevice {
            
            do{
                try device.lockForConfiguration()
            }catch{
                return
            }
            
            if device.flashMode == AVCaptureFlashMode.Off {
                
                device.flashMode = AVCaptureFlashMode.On
                myLabel.text = "フラッシュON"
                self.myLabel.hidden = false //表示
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("onUpdate:"), userInfo: nil, repeats: true)
                
                
            }else{
                
                device.flashMode = AVCaptureFlashMode.Off
                myLabel.text = "フラッシュOFF"
                self.myLabel.hidden = false //表示
                NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("onUpdate:"), userInfo: nil, repeats: true)
                
            }
            
            
            device.unlockForConfiguration()
            
            
            
        }
    }
    //    色調変更メニューON/OFF
    func onchangeColor(sender:UIButton){
        
        if gammaslider.hidden {
            gammaslider.hidden = false
            contrastslider.hidden = false
        }else{
            gammaslider.hidden = true
            contrastslider.hidden = true
        }
        
        
        
    }
    
    let detector = Detector()
    //    var Flame = 0
    //     カメラからの画像を毎フレーム処理する
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
        //        Flame += 1
        
        
       
        
        
        dispatch_sync(dispatch_get_main_queue(), {
            // UIImageへ変換
            let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            self.imageView.image = image

            
            // NSDictionary型のoptionを生成。顔認識の精度を追加する.
            let options : NSDictionary = NSDictionary(object: CIDetectorAccuracyLow, forKey: CIDetectorAccuracy)
            
            // CIDetectorを生成。顔認識をするのでTypeはCIDetectorTypeFace.
            let detector : CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options as? [String : AnyObject])
            
            // detectorで認識した顔のデータを入れておくNSArray.
            let features = detector.featuresInImage(CIImage(image: image)!)
            
            
            UIGraphicsBeginImageContext((self.imageView.image?.size)!)
            self.imageView.image?.drawInRect(CGRectMake(0,0,self.imageView.image!.size.width,self.imageView.image!.size.height))
            
            //得られた顔情報群から矩形を描画していく
            for feature in features{
                //顔の位置と大きさを取得
                var faceRect = (feature as! CIFaceFeature).bounds
                
                //CIImageで取得した座標系とUIKit座標系はy座標が逆方向のため変換する
                faceRect.origin.y = self.imageView.image!.size.height - faceRect.origin.y - faceRect.size.height
                
                /*四角形を描画*/
                // コンテキストを取得
                let context = UIGraphicsGetCurrentContext()
                // 塗りつぶしの色を指定
                CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
                CGContextSetLineWidth(context, 5)
                // 顔の位置と大きさに矩形を描画
                CGContextStrokeRect(context, faceRect)
            }
            //コンテキストから画像に変換
            let drawedImage = UIGraphicsGetImageFromCurrentImageContext()
            //コンテキストを閉じる
            UIGraphicsEndImageContext()
            
            // 表示
            self.imageView.image = drawedImage
            
        })
        
        
        
    }
    //    フレームレート表示用
    //    func onUpdateFlame(timer: NSTimer) {
    //        
    //        print("FPS:\(Flame)")
    //        Flame = 0
    //        
    //    }
    
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    
}
