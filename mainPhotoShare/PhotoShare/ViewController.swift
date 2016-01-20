//
//  ViewController.swift
//  PhotoShare
//
//  Created by ie4a on 2015/09/30.
//  Copyright (c) 2015年 ie4a. All rights reserved.
//

import UIKit

import Alamofire

class ViewController: UIViewController
    //,UIImagePickerControllerDelegate , UINavigationControllerDelegate
{
    
    @IBOutlet weak var bgImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "PhotoShare"
        
        // 色を変数に用意しておく
        //        let color = UIColor(red: 183/255, green: 218/255, blue: 152/255, alpha: 1.0)
        
        // 背景の色を変えたい。
        //        self.navigationController?.navigationBar.barTintColor = color
        
        self.pleaseWaitWithImages([loaderImage!], timeInterval: 0)
        
        LOGIN_WITH_EMAIL(){
            
            [unowned self] auth_user in
            
            self.clearAllNotice()
            self.checkLastEventAndGotoCamera()
            
            
        }
        
    }
    
    func checkLastEventAndGotoCamera() {
        
        print(__FUNCTION__)
        
        let last = read_last_event_json()
        
        print(last)
        
        let start_time = date(last["start_time"].stringValue)
        
        if last["all_day"].intValue == 1 {
            //all_day
            
            print("start_time",start_time)
            print("today",NSDate())
            
            if  start_time != nil && NSDate.areDatesSameDay(NSDate(), dateTwo: start_time!) {
                
                self.performSegueWithIdentifier("directPhotoPicker", sender: nil)
            }
            
        }else{
            //時間指定
            let end_time = date(last["end_time"].stringValue)
            
            if start_time != nil && end_time != nil && (start_time!.compare(end_time!) == .OrderedAscending) {
                self.performSegueWithIdentifier("directPhotoPicker", sender: nil)
            }
        }
    }
    
    func date(dateString: String) -> NSDate? {
        let df = NSDateFormatter()
        
        df.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let date = df.dateFromString(dateString)
        //        print(date)
        return date
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func join(sender: UIButton) {
        
        //        self.performSegueWithIdentifier("toQRCamera", sender: nil)
        /*
        create  alert for QRCODE or URL
        */
        
        let a = UIAlertController(title: "JOIN", message: "方法選択", preferredStyle: .ActionSheet)
        a.popoverPresentationController?.sourceView = view
        a.popoverPresentationController?.sourceRect = sender.frame
        
        //qr画面へ
        a.addAction(UIAlertAction(title: "QR CODE", style: .Default, handler: { [unowned self](act) -> Void in
            //to LOADQR View Controller
            //            self.performSegueWithIdentifier("JoinQR", sender: nil)
            self.performSegueWithIdentifier("toQRCamera", sender: nil)
            }))
        //url入力popup show
        a.addAction(UIAlertAction(title: "URL", style: .Default, handler: { (act) -> Void in
            //            self.performSegueWithIdentifier("JoinURL", sender: nil)
            let urlAlert = UIAlertController(title: "URL入力", message: nil, preferredStyle: .Alert)
            
            urlAlert.addTextFieldWithConfigurationHandler({ (urlField) -> Void in
                urlField.keyboardType = .URL
                
            })
            
            urlAlert.addAction(UIAlertAction(title: "接続", style: .Default, handler: {
                (action) -> Void in
                let url = urlAlert.textFields?[0].text
                
                print(url)
                if url != nil && !url!.isEmpty {
                    joinLink(url!)
                        {
                            json in
                            print(json)
                            goToCamera(json["event"])
                    }
                }
                //                self.performSegueWithIdentifier("JoinURLDirect", sender: nil)
                
                }))
            urlAlert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            
            self.presentViewController(urlAlert, animated: true, completion: nil)
            
        }))
        
        a.addAction(UIAlertAction(title: "キャンセル", style: .Cancel, handler: nil))
        
        presentViewController(a, animated: true, completion: nil)
        
    }
    
    @IBAction func NewRoomCreate(sender: AnyObject) {
        
        let v = RoomCreateViewController()
        self.navigationController?.pushViewController(v, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showEvents" {
            let e = segue.destinationViewController as! EventsTableViewController
            e.needShowPhotos = true
        }
        
        if segue.identifier == "directPhotoPicker" {
            let p = segue.destinationViewController as! MaterialPickerViewController
            p.event = read_last_event_json()
        }
        //
        //        if segue.identifier == "Picker" {
        //            print ("Picker")
        //            let des = segue.destinationViewController as! PickerViewController
        //            des.delegate  = self
        //
        //        }
    }
}

