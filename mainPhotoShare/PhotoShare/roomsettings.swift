//
//  roomsettings.swift
//  PhotoShare
//
//  Created by ie4a on 2015/09/30.
//  Copyright (c) 2015年 ie4a. All rights reserved.
//

import UIKit
import AssetsLibrary


class roomsettings: UIViewController  {
    
    @IBOutlet weak var selectsetting: UISegmentedControl!
    @IBOutlet weak var enddatepicker: UIDatePicker!
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var endtimelabel: UILabel!
    
    @IBOutlet weak var eventTitle: UITextField!
    
    @IBOutlet weak var alldaycfg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        endtimelabel.hidden = true
        enddatepicker.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    タブの変更時の動作
    @IBAction func changetab(sender: AnyObject) {
        
        if selectsetting.selectedSegmentIndex == 1 {
            //            日時まで設定可能にする
            datepicker.datePickerMode = UIDatePickerMode.DateAndTime
            enddatepicker.datePickerMode = UIDatePickerMode.DateAndTime
            enddatepicker.hidden=false
            endtimelabel.hidden=false
        }else{
            //            日程だけ設定可能にする
            datepicker.datePickerMode = UIDatePickerMode.Date
            enddatepicker.datePickerMode = UIDatePickerMode.DateAndTime
            enddatepicker.hidden=true
            endtimelabel.hidden=true
        }
        
        
    }
    
    func dateformat(date:NSDate) -> String {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df.stringFromDate(date)
    }
    
//    parameter : mobile
    
//    @IBAction func submitbutton(sender: AnyObject) {
//        let data = NSMutableDictionary()
//        LOGIN() { user in
//            GET_TOKEN(true){newtoken in data
//                data.setValue(newtoken, forKey: "_token")
//                data.setValue(self.alldaycfg.selectedSegmentIndex, forKey: "all_day")
//                data.setValue(self.eventTitle.text, forKey: "event_name")
//                if self.alldaycfg.selectedSegmentIndex == 0 {
//                   data.setValue(self.dateformat(self.datepicker.date ), forKey: "start_time")
//                }else{
//                data.setValue(self.dateformat(self.datepicker.date ), forKey: "start_time")
//                data.setValue(self.dateformat(self.enddatepicker.date ), forKey: "end_time")
//                }
//                data.setValue(1, forKey: "mobile")
//                print(data)
//                let req = mgr.request(.POST, URL("events/create"), parameters:data as? [String : AnyObject])
//                req.responseJSON(completionHandler: { (res) -> Void in
//                    if let val = res.result.value {
//                        let json = JSON(val)
//                        print(json)
//                        
//                        let appd:AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
//                        AppDelegate.noweventid = json["id"].stringValue
////                        print(appd.noweventid)
//                        
//                    } })
//                    .responseString{string in
//                        
//                        print(string)
//                }
//            }
//            
//        }
//        
//        
//    }
    
    @IBAction func eventChanged(sender: AnyObject) {
        
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

