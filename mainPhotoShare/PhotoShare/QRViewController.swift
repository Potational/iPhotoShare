//
//  QRViewController.swift
//  PhotoShare
//
//  Created by 4423 on 2015/10/07.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 撮影ボタンを作成.
        let myButton = UIButton(frame: CGRectMake(0,0,120,60))
        myButton.backgroundColor = UIColor.redColor()
        myButton.layer.masksToBounds = true
        myButton.setTitle("カメラへ戻る", forState: .Normal)
        myButton.layer.cornerRadius = 60 / 2.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func onClickMyButton(sender:UIButton){
        print("onclick")
        self.dismissViewControllerAnimated(true, completion: nil)
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
