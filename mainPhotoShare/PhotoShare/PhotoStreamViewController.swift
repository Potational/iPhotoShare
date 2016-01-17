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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let patternImage = UIImage(named: "Pattern") {
        //            self.view.backgroundColor = UIColor(patternImage: patternImage)
        //        }
        // Set the PinterestLayout delegate
        
        if let layout = self.collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
            layout.numberOfColumns = numberOfColumns
        }
        
        self.collectionView!.backgroundColor = UIColor.blackColor()
        self.collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
        
        loadPhotos()
        
    }
    
    func loadPhotos(then: (()->Void)? = nil) {
        let req = mgr.request(.GET, URL("events/photos/\(event["id"])?mobile=1"))
        
        //        debugPrint(req)
        
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
        return UIImage.gifWithName("preloader2")
    }()
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        if let layout = self.collectionView?.collectionViewLayout as? PinterestLayout {
            layout.cache = []
            layout.numberOfColumns = numberOfColumns
            layout.invalidateLayout()
        }
        
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
        
        cell.imageView.image = loader
        cell.captionLabel.text = nil
        
        if let photo = photos?[indexPath.item] {
            
            let p = Photo(photoJson: photo)
            
            ImageDownloader.downloadImage(urlImage: p.imgLink, completionBlock: { (imageDownloaded) -> () in
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    cell.captionLabel.text = p.title
                    cell.imageView.image = imageDownloaded
                    //                    print(imageDownloaded)
                })
            })
            
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        print(indexPath)
        if let photo = photos?[indexPath.item]{
//            print (photo)
            sel_photo = photo
            performSegueWithIdentifier("toDownloadPhoto", sender: nil)
        }
        
    }
    
    var sel_photo : JSON!
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toDownloadPhoto" {
            let des = segue.destinationViewController as! DownloadPhotoViewController
            des.photoLink = sel_photo["link"].stringValue
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

