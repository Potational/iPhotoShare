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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadPhotoView.downloadedFrom(link: self.photoLink)
        
        //ロングプレスジェスチャー
        let longPG = UILongPressGestureRecognizer(target: self, action: "doGesture:")
        //ジェスチャーの追加
        self.view.addGestureRecognizer(longPG)
        // Do any additional setup after loading the view.
    }
    
    func doGesture(gesture:UIGestureRecognizer){
        if let longPressGesture = gesture as? UILongPressGestureRecognizer{
            longPress(longPressGesture)
        }
    }
    
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
