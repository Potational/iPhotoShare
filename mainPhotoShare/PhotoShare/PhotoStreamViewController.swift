//
//  PhotoStreamViewController.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoStreamViewController: UICollectionViewController {
    
    //  var photos = Photo.allPhotos()
    var photos : JSON?
    var event: JSON!
    var sel_photo : JSON!
    var sel_photo_idx : Int = 0
    
    var needDoneBarButtonItem : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(__FUNCTION__)
        
        title = event?["event_name"].string
        
        layout?.delegate = self
        layout?.numberOfColumns = numberOfColumns
        
        self.collectionView!.backgroundColor = UIColor.blackColor()
        self.collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        loadPhotos()
        addDoneBarButtonItemIfNeeded()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Fade)
    }
   
    func loadPhotos(then: (()->Void)? = nil) {
        
        guard event != nil else {
            return
        }
        layout?.cache = []
        
        let req = mgr.request(.GET, URL("events/photos/\(event["id"].stringValue)?mobile=1"))
        
        self.pleaseWaitWithImages([loaderImage!], timeInterval: 0)
        
        req.responseJSON {
            [weak self]
            (res) -> Void in
            
            if let err = res.result.error {
                self?.alertError(err)
                return
            }
            
            let json = JSON(res.result.value ?? [])
            
            self?.photos = json["photos","all"]
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.collectionView?.reloadData()
            })
            
            self?.clearAllNotice()
            then?()
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        
        cell.imageView.image = loader
        cell.captionLabel.text = nil
        
        if let photo = photos?[indexPath.item] {
            
//            let p = Photo(photoJson: photo)
            
            ImageDownloader.downloadImage(urlImage: photo["link_thumb"].stringValue, completionBlock: { (imageDownloaded) -> () in
                
                cell.captionLabel.text = photo["title"].string
                cell.captionLabel.textAlignment = .Center
                UIView.transitionWithView(cell.imageView, duration: 0.3,
                    options: UIViewAnimationOptions.TransitionCrossDissolve,
                    animations: { () -> Void in
                        cell.imageView.image = imageDownloaded
                    }, completion: { (ok) -> Void in
                        cell.imageView.image = imageDownloaded
                })
            })
            
            
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let photo = photos?[indexPath.item]{
            sel_photo = photo
            sel_photo_idx = indexPath.item
            performSegueWithIdentifier("toDownloadPhoto", sender: nil)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDownloadPhoto" {
            
            let downloadView = segue.destinationViewController as! DownloadPhotoViewController
            
            downloadView.photo = sel_photo
            downloadView.photos = photos
            downloadView.sel_photo_idx = sel_photo_idx
        }
    }
    func addDoneBarButtonItemIfNeeded(){
        if needDoneBarButtonItem {
            self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done:"), animated: true)
        }
    }
    func done(button : UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    lazy var layout : PinterestLayout? = {
        return self.collectionView?.collectionViewLayout as? PinterestLayout
    }()
    
    
    @IBAction func reloadPhotos(sender: UIBarButtonItem) {
        
        loadPhotos()
    }
    
    lazy var loader : UIImage? = {
        return UIImage.gifWithName("panda_102")
    }()
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        layout?.cache = []
        layout?.numberOfColumns = numberOfColumns
        layout?.invalidateLayout()
        
    }
    var numberOfColumns : Int {
        get {
            return isLandscape() ? 3 : 2
        }
    }
    func isLandscape() -> Bool {
        let isLanscape = UIDevice.currentDevice().orientation.isLandscape.boolValue
        return isLanscape
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return UIStatusBarStyle.LightContent
//    }
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
}


extension PhotoStreamViewController : PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat {
        return 100
    }
    
    // 2. Returns the annotation size based on the text
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return 20
    }
    
}

