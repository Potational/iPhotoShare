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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = event?["event_name"].string
        
        layout?.delegate = self
        layout?.numberOfColumns = numberOfColumns
        
        self.collectionView!.backgroundColor = UIColor.blackColor()
        self.collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        loadPhotos()
    }
    lazy var layout : PinterestLayout? = {
        return self.collectionView?.collectionViewLayout as? PinterestLayout
    }()
    
    //    override func viewWillAppear(animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        loadPhotos()
    //    }
    
    @IBAction func reloadPhotos(sender: UIBarButtonItem) {
        
        loadPhotos()
    }
    func loadPhotos(then: (()->Void)? = nil) {
        
        layout?.cache = []
        
        let req = mgr.request(.GET, URL("events/photos/\(event["id"])?mobile=1"))
        
        req.responseJSON {
            [weak self]
            (res) -> Void in
            
            if let err = res.result.error {
                self?.alert(__FUNCTION__, message: err.description)
            }
            
            let json = JSON(res.result.value ?? [])
            
            self?.photos = json["photos","all"]
            
            self?.collectionView?.reloadData()
            
            then?()
        }
    }
    
    lazy var loader : UIImage? = {
        return UIImage.gifWithName("loader1")
    }()
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        //        if let layout = self.collectionView?.collectionViewLayout as? PinterestLayout {
        layout?.cache = []
        layout?.numberOfColumns = numberOfColumns
        layout?.invalidateLayout()
        //        }
        
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
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        
        cell.imageView.image = nil
        cell.captionLabel.text = nil
        
        if let photo = photos?[indexPath.item] {
            
            let p = Photo(photoJson: photo)
            
            ImageDownloader.downloadImage(urlImage: p.imgLink, completionBlock: { (imageDownloaded) -> () in
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.captionLabel.text = p.title
                    
                    UIView.transitionWithView(cell.imageView, duration: 0.3,
                        options: UIViewAnimationOptions.TransitionCrossDissolve,
                        animations: { () -> Void in
                            cell.imageView.image = imageDownloaded
                        }, completion: { (ok) -> Void in
                            cell.imageView.image = imageDownloaded
                    })
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
            let des = segue.destinationViewController as! DownloadPhotoViewController
            //            des.photoLink = sel_photo["link"].stringValue
            des.photo = sel_photo
            des.photos = photos
            des.sel_photo_idx = sel_photo_idx
        }
    }
    
    
}

//extension PhotoStreamViewController {
//
//    }

extension PhotoStreamViewController : PinterestLayoutDelegate {
    // 1. Returns the photo height
    func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath:NSIndexPath , withWidth width:CGFloat) -> CGFloat {
        
        //        let photo = photos[indexPath.item]
        //        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? AnnotatedPhotoCell
        //        let boundingRect =  CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        //
        //        if let photo = cell?.photo {
        //            let rect  = AVMakeRectWithAspectRatioInsideRect(photo.image.size, boundingRect)
        //            return rect.size.height
        //        }
        return 100
    }
    
    // 2. Returns the annotation size based on the text
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        
        //        let annotationPadding = CGFloat(4)
        //        let annotationHeaderHeight = CGFloat(17)
        //
        //        //                let photo = photos[indexPath.item]
        //        let cell = (collectionView.cellForItemAtIndexPath(indexPath) as? AnnotatedPhotoCell)
        ////        if let photo = cell?.photo {
        //            let font = UIFont(name: "AvenirNext-Regular", size: 10)!
        //            let commentHeight = photo.heightForcreated_at(font, width: width)
        //            let height = annotationPadding + annotationHeaderHeight + commentHeight + annotationPadding
        //            return height
        ////        }
        return 20
    }
    
}

