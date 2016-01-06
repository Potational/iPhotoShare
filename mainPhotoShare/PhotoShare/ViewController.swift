//
//  ViewController.swift
//  PhotoShare
//
//  Created by ie4a on 2015/09/30.
//  Copyright (c) 2015年 ie4a. All rights reserved.
//

import UIKit

import Alamofire

class ViewController: UIViewController {
    
    
    @IBAction func showEvents(sender: AnyObject) {
        let v = EventsTableViewController(nibName:"EventsTableViewController",bundle: nil)
        self.navigationController?.pushViewController(v, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nowViewController = self
        print(__FUNCTION__)
        
        // 色を変数に用意しておく
        let color = UIColor(red: 183/255, green: 218/255, blue: 152/255, alpha: 1.0)
        
        // 背景の色を変えたい。
        self.navigationController?.navigationBar.barTintColor = color
        
        tryLogin()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tryLogin() {
      
        LOGIN_WITH_EMAIL()
        
    }
    
    @IBAction func NewRoomCreate(sender: AnyObject) {
        
        let v = RoomCreateViewController()
        self.navigationController?.pushViewController(v, animated: true)
        
    }
    
    @IBAction func myResumeButton(sender: AnyObject) {
        
        
    }
}

