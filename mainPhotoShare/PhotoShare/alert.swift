//
//  alert.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/02.
//  Copyright © 2015年 ZEmac. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(title:String? = nil , message : String? = nil){
        
        let al = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        al.addAction(UIAlertAction(title: "了解", style: .Default, handler: nil))
        
        self.presentViewController(al, animated: true, completion: nil)
    }
}

extension UIImageView {
    func downloadedFrom(link link:String, contentMode mode: UIViewContentMode = .ScaleAspectFit) {
        guard
            let url = NSURL(string: link)
            else {return}
        contentMode = mode
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, _, error) -> Void in
            guard
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
                    self.image = image
                    }, completion: { (ok) -> Void in
                        self.image = image
                })
                
                
            }
        }).resume()
    }
}