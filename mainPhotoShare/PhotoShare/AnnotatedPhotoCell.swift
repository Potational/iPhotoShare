//
//  AnnotatedPhotoCell.swift
//  RWDevCon
//
//  Created by Mic Pringle on 26/02/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet  weak var imageView: UIImageView!
    @IBOutlet  weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet  weak var captionLabel: UILabel!
    @IBOutlet  weak var commentLabel: UILabel!
    
//    var photo: Photo? {
//        didSet {
//            if let photo = photo {
//                
//                ImageDownloader.downloadImage(urlImage: photo.imgLink, completionBlock: { (imageDownloaded) -> () in
//                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                        self.imageView.image = imageDownloaded?.decompressedImage
//                        print(self.imageView.image)
//                        self.captionLabel.text = photo.title
////                        self.applyLayoutAttributes(self.imageViewHeightLayoutConstraint)
//                    })
//                    
//                })
//                
//
////                commentLabel.text = photo.created_at
//            }
//        }
//    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
//        print(__FUNCTION__)
        if let attributes = layoutAttributes as? PinterestLayoutAttributes {
            imageViewHeightLayoutConstraint.constant = attributes.photoHeight
        }
    }
}
