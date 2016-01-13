//
//  DownloadDetailViewController.swift
//  PhotoShare
//
//  Created by kawanamitakanori on 2015/12/15.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit

let DownloadDetailCell = "DownloadDetailCell"
class DownloadDetailViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    @IBOutlet weak var DownloadDetailView: UICollectionView!
    var eventId : String! = ""
    var photoLinks : JSON = nil
    var selectedPhotoLink = ""
    var selectedphotonum = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadTableData(){
        
        let req = request(.GET, URL("/events/photos") + "/\(self.eventId)",parameters: GLO_PARAMS)
        req.responseJSON { [weak self] (res) -> Void in
            
            if let err = res.result.error {
                self?.alert(__FUNCTION__, message: err.description)
            }
            
            print(JSON(res.result.value ?? []))
            
            self!.photoLinks = JSON(res.result.value ?? [])["links"]
            print(self?.photoLinks)
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self?.DownloadDetailView.reloadData()
                if self!.photoLinks.count == 0{
                    self!.noPhotoAlert()
                }
            })
        }
    }
    
    func noPhotoAlert(){
            let alert: UIAlertController = UIAlertController(title: "", message: "画像は投稿されていません。", preferredStyle: .Alert)
            let okAction = UIAlertAction(title: "OK", style: .Default) { action in }
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
    }
    

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:DownloadDetailCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(DownloadDetailCell, forIndexPath: indexPath) as! DownloadDetailCollectionViewCell
        print(photoLinks[indexPath.row].stringValue)
        let photoLink = photoLinks[indexPath.row].stringValue + "/?thumb=1"
        cell.DownloadDetailImage.downloadedFrom(link: photoLink)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoLinks.count
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(self.view.frame.size.width/6,self.view.frame.size.height/8)
    }
    
    //Cellが選択された際に呼び出される
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedPhotoLink = photoLinks[indexPath.row].stringValue
        performSegueWithIdentifier("toDownloadPhoto",sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toDownloadPhoto") {
            let DownloadPhotolView : DownloadPhotoViewController =  (segue.destinationViewController as? DownloadPhotoViewController)!
            print(self.selectedPhotoLink)
            DownloadPhotolView.photoLink = selectedPhotoLink

        }
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
