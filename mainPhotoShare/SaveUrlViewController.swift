//
//  SaveUrlViewController.swift
//  PhotoShare
//
//  Created by 4423 on 2015/10/14.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit

class SaveUrlViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Labelとボタン配置
        let myLabel:UILabel = UILabel(frame: CGRectMake(0,0,171,21))
        myLabel.layer.position = CGPoint(x: 100,y: 150)// 位置
        myLabel.text = "イベントURLを表示"// 文字
        myLabel.font = UIFont.systemFontOfSize(17)// フォントサイズ
        myLabel.textAlignment = NSTextAlignment.Center// 文字を中央寄せ
        myLabel.layer.masksToBounds = true// 角丸
        myLabel.layer.cornerRadius =  10.0// コーナーの半径
        // UIボタンをViewに追加.
        self.view.addSubview(myLabel)
        //TextBox
        let myText:UITextField = UITextField(frame: CGRectMake(0,0,270,21))
        myText.layer.position = CGPoint(x: 150,y: 180)// 位置
        myText.font = UIFont.systemFontOfSize(20)// フォントサイズ
        myText.textAlignment = NSTextAlignment.Center// 文字を中央寄せ
        myText.borderStyle=UITextBorderStyle.RoundedRect
        // UIボタンをViewに追加.
        self.view.addSubview(myText)
        
        // 撮影ボタンを作成.
        let myButton = UIButton(frame: CGRectMake(0,0,60,60))
        myButton.layer.masksToBounds = true
        myButton.setTitle("接続", forState: .Normal)
        myButton.setTitleColor(UIColor.blueColor(),forState: .Normal)
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:210)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onClickMyButton(sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewControllerWithIdentifier("DownloadViewController")
        let rightViewController = storyboard.instantiateViewControllerWithIdentifier("RightViewController") as! RightViewController
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        rightViewController.mainViewController = nvc
        
        nvc.setNavigationBarHidden(false, animated: true)
        
        performSegueWithIdentifier("toDownloadViewController",sender: nil)
    }
    


}
