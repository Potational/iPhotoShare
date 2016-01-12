//
//  PickerViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2016/01/12.
//  Copyright © 2016年 ie4a. All rights reserved.
//

import UIKit

class PickerViewController: UIImagePickerController {

    override func viewDidLoad() {
        super.viewDidLoad()
        sourceType = .Camera
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
