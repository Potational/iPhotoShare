//
//  Photo.swift
//  RWDevCon
//
//  Created by Mic Pringle on 04/03/2015.
//  Copyright (c) 2015 Ray Wenderlich. All rights reserved.
//

import UIKit

class Photo {
    
    //  class func allPhotos() -> [Photo] {
    //    var photos = [Photo]()
    //    if let URL = NSBundle.mainBundle().URLForResource("Photos", withExtension: "plist") {
    //      if let photosFromPlist = NSArray(contentsOfURL: URL) {
    //        for dictionary in photosFromPlist {
    //          let photo = Photo(dictionary: dictionary as! NSDictionary)
    //          photos.append(photo)
    //        }
    //      }
    //    }
    //    return photos
    //  }
    
    var title: String
    var created_at: String
    var image: UIImage!
    var imgLink : String!
    
    init(title: String, created_at: String, image: UIImage) {
        self.title = title
        self.created_at = created_at
        self.image = image
    }
    init(imgLink: String, title: String, created_at: String){
        self.imgLink = imgLink
        self.title = title
        self.created_at = created_at
    }
    convenience init(photoJson : JSON){
        let title = photoJson["title"].stringValue
        let created_at = photoJson["created_at"].stringValue
        let imgLink = photoJson["link_thumb"].stringValue
        self.init(imgLink:imgLink, title: title, created_at: created_at)
    }
    
    
    func heightForcreated_at(font: UIFont, width: CGFloat) -> CGFloat {
        let rect = NSString(string: created_at).boundingRectWithSize(CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return ceil(rect.height)
    }
    
}
