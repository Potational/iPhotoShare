//
//  QRZoomViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2016/01/14.
//  Copyright © 2016年 ie4a. All rights reserved.
//

import UIKit

class QRZoomViewController: UIViewController {
    
    @IBOutlet weak var qrImageView: UIImageView!
    
    var qrImage : UIImage?
    
    var event : JSON!
    
    @IBOutlet weak var eventLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        qrImageView?.image = self.qrImage
        
        qrImageView?.addTapGesture(tapNumber: 1, action: {
            [weak self](ges) -> () in
            self?.dismissViewControllerAnimated(true, completion: nil)
        })
        
        eventLabel.text = event?["event_name"].string
        
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
