//
//  URLViewController.swift
//  PhotoShare
//
//  Created by 4423 on 2015/10/07.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit


class URLViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let appd:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        
//        print(appd.noweventid)
        
        

        let myLabel = UILabel(frame: CGRectMake(0,0,250,60))
        myLabel.layer.position = CGPoint(x:120, y:150)
        myLabel.text = "現在のアルバムURL"
        myLabel.font = UIFont.systemFontOfSize(25)
        myLabel.textAlignment = NSTextAlignment.Center
        myLabel.layer.masksToBounds = true
        myLabel.layer.cornerRadius = 20.0
        self.view.addSubview(myLabel)

        
        
        if AppDelegate.noweventid == nil {
            let myUrlLabel = UILabel()
            myUrlLabel.frame = CGRectMake(0,0,320,60)
            myUrlLabel.layer.position = CGPoint(x:200, y:200)
            myUrlLabel.text = "現在アルバムに参加していません"
            myUrlLabel.font = UIFont.systemFontOfSize(20)
            myUrlLabel.textAlignment = NSTextAlignment.Left
            myUrlLabel.layer.masksToBounds = true
            self.view.addSubview(myUrlLabel)
            
        }else{
            let myUrlTextView = UITextView()
            myUrlTextView.frame = CGRectMake(0,0,300,60)
            myUrlTextView.layer.position = CGPoint(x:180, y:200)
            AppDelegate.noweventid = AppDelegate.noweventid?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let urltext = "https://www.photoshare.space/events/join/\(AppDelegate.noweventid!)"
            print(urltext)
            myUrlTextView.text = urltext
            myUrlTextView.font = UIFont.systemFontOfSize(15)
            myUrlTextView.dataDetectorTypes = UIDataDetectorTypes.All
            myUrlTextView.editable = false
            self.view.addSubview(myUrlTextView)

        }
        
        
        // 戻るボタンを作成.
        let myButton = UIButton(frame: CGRectMake(0,0,120,60))
        myButton.backgroundColor = UIColor.redColor()
        myButton.layer.masksToBounds = true
        myButton.setTitle("カメラへ戻る", forState: .Normal)
        myButton.layer.cornerRadius = 60 / 2.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton)
            
        }

        
        
        // Do any additional setup after loading the view.
    

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
