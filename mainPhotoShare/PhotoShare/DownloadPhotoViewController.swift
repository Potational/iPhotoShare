//
//  DownloadPhotoViewController.swift
//  PhotoShare
//
//  Created by kawanamitakanori on 2015/12/27.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit

class DownloadPhotoViewController: UIViewController {

    @IBOutlet weak var downloadPhotoView: UIImageView!
    var photoLink : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadPhotoView.downloadedFrom(link: self.photoLink)
        
        // Do any additional setup after loading the view.
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
