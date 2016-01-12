//
//  RoomCreateViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/02.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit

import Eureka

import Alamofire


import RealmSwift

var sel_event : Event?

// Event model

class Event: Object {
    dynamic var id : String?
    dynamic var event_name : String?
    dynamic var user_id : String?
    dynamic var share_id : String?
    dynamic var all_day : String?
    dynamic var start_time : String?
    dynamic var end_time : String?
    dynamic var created_at : String?
    
    class func write(data: AnyObject, done: ((event : Event?)-> Void )? = nil){
        let r = try! Realm()
        
        try! r.write(){
            
            let new_event = r.create(Event.self, value: data)
            
            Defaults.last_event_id = String(new_event.id)
            
            //            print(Defaults.last_event_id)
            
            sel_event = new_event
            
            done?(event: sel_event)
        }
    }
    
    class func new(data: AnyObject, done: ((event : Event?)-> Void )? = nil){
        let event = Event(value: data)
        //        let r = try! Realm()
        //        let event = r.create(Event.self, value: data)
        //        sel_event = event
        done?(event: event)
    }
}



class RoomCreateViewController: FormViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let bg = UIImageView(image: UIImage(named: "Home17"))
        //        bg.frame = CGRect(x: 0, y: 0, w: view.frame.size.width, h: view.frame.size.height)
        let bg = UIColor.whiteColor()//UIColor(patternImage: UIImage(named: "pattern2")!)
        tableView?.separatorStyle = .None
        tableView?.backgroundColor = bg
        
        
        self.title = "NEW"
        form +++=
            Section()
            <<< TextRow("event_name"){
                $0.title = "イベント名"
                $0.cell.contentView.backgroundColor = bg
                $0.cell.textField.becomeFirstResponder()
            }
            <<< SegmentedRow<String>("all_day") {
                $0.options = ["本日のみ", "時間で設定"]
                $0.title = "共有時間"
                $0.value = "本日のみ"
                $0.cell.contentView.backgroundColor = bg
                }.onChange({ (row) -> () in
                    print(row.value)
                    
                    }
            )
            
            <<< DateTimeInlineRow("start_time"){
                $0.minimumDate = NSDate()
                $0.value = NSDate()
                $0.dateFormatter = NSDateFormatter.DateAndTime
                $0.title = "開始時間"
                $0.cell.contentView.backgroundColor = bg
            }
            <<< DateTimeInlineRow("end_time"){
                $0.minimumDate = NSDate()
                $0.value = NSDate().dateByAddingTimeInterval(3600)
                $0.title = "終了時間"
                $0.dateFormatter = NSDateFormatter.DateAndTime
                $0.hidden = "$all_day == '本日のみ'"
                $0.cell.contentView.backgroundColor = bg
            }
            <<< ButtonRow("submit") {
                $0.title = "新規アルバム作成"
                }.onCellSelection({ [weak self](cell, row) -> () in
                    
                    var new_event_data : [String: AnyObject] = [String:AnyObject]()
                    
                    if let formvals = self?.form.values() {
                        for (key,val) in formvals {
                            if(val != nil) {
                                if key == "all_day" {
                                    let all_day = (val as? String == "本日のみ" ? 1 : 0)
                                    new_event_data["all_day"] = all_day
                                    
                                    if all_day == 0 {//時間の指定
                                        if let start_time = formvals["start_time"] as? NSDate {
                                            if let end_time = formvals["end_time"] as? NSDate {
                                                if start_time.compare(end_time) == NSComparisonResult.OrderedDescending {
                                                    self?.alert("日付を正しく入力してください", message: nil)
                                                    return;
                                                }
                                            }
                                        }
                                    }
                                }else{
                                    if let v = val as? NSDate {
                                        new_event_data[key] = NSDateFormatter.sqlDateTime.stringFromDate(v)
                                    }else{
                                        new_event_data[key] = val as? String
                                    }
                                }
                            }
                        }
                    }
                    
                    if new_event_data["event_name"] == nil {
                        self?.alert("イベント名を入力してください", message: nil)
                        return
                    }
                    
                    print(new_event_data)
                    
                    self?.new_room_create(new_event_data)
                    
                    })
    }
    
    
    //MARK: send to SERVER & CREATE
    func new_room_create(data: [String:AnyObject]){
        
        build_data(data, done: { (all_data) -> Void in
            
            mgr.request(.POST, baseUrl(URL_TYPE.EVENT_CREATE),parameters: all_data)
                .responseJSON{ [weak self] res in
                    
                    //write event to locale
//                    self?.save_new_room_data(res.result.value!)
                    //
                    
                    print(res)
                    Defaults.last_event_id = JSON(res.result.value ?? [])["id"].stringValue
                    self?.goToCamera()
            }
            
        })
        
    }
    
    //    MARK: SAVE by Realm and GO TO CAMERA
    func save_new_room_data(res : AnyObject ){
        
        Event.write(res){
            event in
            Defaults.last_event_id = String(event?.id)
            self.goToCamera()
        }
        
    }
    
    //    MARK: GO TO KAMERA
    
    func goToCamera(){
        
        print(__FUNCTION__)
        
        let v = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("CamController") as! CamController
        self.navigationController?.pushViewController(v, animated: true)
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
