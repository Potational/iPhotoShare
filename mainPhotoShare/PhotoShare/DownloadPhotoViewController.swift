//
//  DownloadPhotoViewController.swift
//  PhotoShare
//
//  Created by kawanamitakanori on 2015/12/27.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit
import Accounts
import AVFoundation

class DownloadPhotoViewController: UIViewController {

    @IBOutlet weak var downloadPhotoView: UIImageView!
    var photoLink : String = ""
    var selectPhotoId = ""
    var photoLiks:[String] = []
    var index = 0
    var indexcount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadPhotoView.downloadedFrom(link: self.photoLink)
        
        //ロングプレスジェスチャー
        let longPG = UILongPressGestureRecognizer(target: self, action: "doGesture:")
        //ジェスチャーの追加
        self.view.addGestureRecognizer(longPG)
        // Do any additional setup after loading the view
        
        
        // 右方向へのスワイプ
        let gestureToRight = UISwipeGestureRecognizer(target: self, action: "goBack")
        gestureToRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(gestureToRight)
        
        // 左方向へのスワイプ
        let gestureToLeft = UISwipeGestureRecognizer(target: self, action: "goForward")
        gestureToLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(gestureToLeft)
        
      
   
//        今表示してるインデックス取得
        index = photoLiks.indexOf(photoLink)!
        print(index)
        
        indexcount = photoLiks.count - 1
        
    }
    
    
    
  
    
    
    func doGesture(gesture:UIGestureRecognizer){
        if let longPressGesture = gesture as? UILongPressGestureRecognizer{
            longPress(longPressGesture)
        }
        
       
    }
    
//    左右にスワイプ時の動作
    func goBack(){
        print("goBack")
        if index - 1 >= 0{
            index -= 1
            print(index)
            downloadPhotoView.downloadedFrom(link: photoLiks[index])
        }else{
            let alertController = UIAlertController(title: "PhotoShare", message: "これが先頭の画像です。", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
        
        
    }
    
    func goForward(){
        print("goForward")
        if index + 1 <= indexcount {
            index += 1
            print(index)
            downloadPhotoView.downloadedFrom(link: photoLiks[index])
        }else{
            let alertController = UIAlertController(title: "PhotoShare", message: "これが最後の画像です。", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            
            presentViewController(alertController, animated: true, completion: nil)
        }
      
    }
//    スワイプここまで
    
    //ジェスチャー処理中身
    private func longPress(gesture:UILongPressGestureRecognizer){
        
        if gesture.state != .Began{
            return
        }
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            }) { (finished) -> Void in
                
                
                // 共有する項目
                let shareImage =  self.downloadPhotoView.image
                
                
                // 初期化処理
                let activityVC = UIActivityViewController(activityItems: [shareImage!], applicationActivities: nil)
                
                // 使用しないアクティビティタイプ
                let excludedActivityTypes = [
                  UIActivityTypeMail,
                    UIActivityTypeMessage,
                    UIActivityTypePrint,
                    UIActivityTypeCopyToPasteboard,
                    UIActivityTypeAssignToContact,
                    UIActivityTypeAddToReadingList,
                    UIActivityTypePostToFlickr,
                    UIActivityTypePostToVimeo,
                    UIActivityTypePostToWeibo,
                    UIActivityTypePostToTencentWeibo
                ]
                
                activityVC.excludedActivityTypes = excludedActivityTypes
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                // UIActivityViewControllerを表示
                self.presentViewController(activityVC, animated: true, completion: nil)
                
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
