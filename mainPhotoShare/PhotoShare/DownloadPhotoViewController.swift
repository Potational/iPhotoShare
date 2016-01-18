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
import AssetsLibrary
import Photos

class DownloadPhotoViewController: UIViewController {
    
    @IBOutlet weak var downloadPhotoView: UIImageView!
    //    var photoLink : String!
    var photo : JSON!
    var photos : JSON!
    var sel_photo_idx : Int = 0
    
    @IBOutlet weak var byat: UILabel!
    
    @IBOutlet weak var countItem: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = photo["title"].string
        
        reloadCountItemLabel()
        //        downloadPhotoView.downloadedFrom(link: photo["link"].stringValue)
        
        //ロングプレスジェスチャー
        let longPG = UILongPressGestureRecognizer(target: self, action: "doGesture:")
        //ジェスチャーの追加
        self.view.addGestureRecognizer(longPG)
        // Do any additional setup after loading the view.
        // add swipe left right
        addSwipeImageView()
    }
    
    func addSwipeImageView() {
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeRight.direction = .Right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "swipe:")
        swipeLeft.direction = .Left
        self.view.addGestureRecognizer(swipeRight)
        self.view.addGestureRecognizer(swipeLeft)
    }
    
    func swipe(gesture: UIGestureRecognizer) {
        if let swipeG = gesture as? UISwipeGestureRecognizer {
            switch swipeG.direction {
            case UISwipeGestureRecognizerDirection.Left :
                //nex
                reloadCountItemLabel(true)
            case UISwipeGestureRecognizerDirection.Right :
                //prev
                reloadCountItemLabel(false)
            default:
                break
            }
        }
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
    
    @IBAction func next(sender: UIBarButtonItem) {
        reloadCountItemLabel(true)
    }
    @IBAction func prev(sender: UIBarButtonItem) {
        reloadCountItemLabel(false)
    }
    
    func reloadCountItemLabel(next:Bool? = nil) {
        if next != nil {
            if next == true {
                //next
                
                sel_photo_idx += 1
                if sel_photo_idx > (photos.count - 1) {
                    sel_photo_idx = 0
                }
            }else{
                //prev
                
                sel_photo_idx -= 1
                if sel_photo_idx < 0 {
                    sel_photo_idx = photos.count - 1
                }
            }
        }
        if sel_photo_idx > (photos.count - 1) {
            sel_photo_idx = 0
        }
        photo = photos[sel_photo_idx]
        downloadPhotoView.downloadedFrom(link: photo["link"].stringValue)
        title = photo["title"].string
        //        print(photo)
        byat.text = "by \(photo["user","name"].stringValue) at \(photo["created_at"].stringValue)"
        countItem.title = "\(sel_photo_idx + 1) / \(photos.count)"
    }
    @IBAction func save(sender: UIBarButtonItem) {
        if let img = downloadPhotoView.image {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                
                PHAssetChangeRequest.creationRequestForAssetFromImage(img)
                
                },completionHandler: {
                    [weak self]success, error in
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self?.save_ok()
                    })
                    print("added image to album")
                    print(error)
                    
                })
            
        }
    }
    
    func save_ok() {
        let al = UIAlertController(title: "保存完了", message: nil, preferredStyle: .Alert)
        al.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(al, animated: true, completion: nil)
        
    }
    
    @IBAction func other_actions(sender: UIBarButtonItem) {
        
        let actions  = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if UI_USER_INTERFACE_IDIOM() == .Pad {
            actions.popoverPresentationController?.sourceView = view
            actions.popoverPresentationController?.barButtonItem = sender
            //            actions.popoverPresentationController?.sourceRect = sender.accessibilityFrame
        }
        
        let delAction = UIAlertAction(title: "削除", style: .Destructive, handler: { (act) -> Void in
            print(act)
            let reqUrl = URL("photos/delete/\(self.photo["id"].stringValue)")
            GET_TOKEN(true){
                newtoken in
                mgr.request(.POST, reqUrl, parameters:["_token":newtoken,"mobile":1])
                    .responseJSON(completionHandler: { (res) -> Void in
                        if let err = res.result.error {
                            print(err)
                            return
                        }
                        
                        let j = JSON(res.result.value ?? [])
                        if j["deleted"].bool == true {
                            self.photos = j["photos"]
                            self.reloadCountItemLabel()
                        }else{
                            let a = UIAlertController(title: "削除できません。", message: nil, preferredStyle: .Alert)
                            let okAction = UIAlertAction(title: "了解", style: .Default, handler: nil)
                            a.addAction(okAction)
                            self.presentViewController(a, animated: true, completion: nil)
                        }
                        
                        
                    })
                    .responseString(completionHandler: { (res) -> Void in
                    })
            }
        })
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil)
        
        actions.addAction(delAction)
        actions.addAction(cancelAction)
        
        presentViewController(actions, animated: true, completion: nil)
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
