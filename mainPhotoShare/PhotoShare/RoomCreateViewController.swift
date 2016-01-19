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


class RoomCreateViewController: FormViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        let bg = UIImageView(image: UIImage(named: "Home17"))
        //        bg.frame = CGRect(x: 0, y: 0, w: view.frame.size.width, h: view.frame.size.height)
        let bg = UIColor.whiteColor()
        //UIColor(patternImage: UIImage(named: "pattern2")!)
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
                .responseJSON{
                    [weak self] event in
                    
                    self?.navigationController?.popViewControllerAnimated(false)
                    
                    let event = JSON(event.result.value ?? [])
                    
                    if event != nil {
                        joinLink(event){
                            _ in
                            
                            write_last_event_json(event)
                            goToCamera(event)
                        }
                    }
                    
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
