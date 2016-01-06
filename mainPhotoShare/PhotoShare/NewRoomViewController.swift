//
//  NewRoomViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/02.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit
import Former

class NewRoomViewController: FormViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let event_name = TextFieldRowFormer<FormTextFieldCell>(){
            $0.titleLabel.text = "イベント名"
        }
        
        let time_setting = SegmentedRowFormer<FormSegmentedCell>(){
            
            $0.titleLabel.text = "共有時間の設定"
            
            }.configure {
                $0.segmentTitles = ["本日のみ", "時間で指定"]
            }.onSegmentSelected {[weak self] (idx, str) -> Void in
                self?.time_setting_changed(idx, str: str)
        }
        
        let createButton = LabelRowFormer<FormLabelCell>(){
            $0.textLabel?.text = "完了"
            $0.textLabel?.textColor = .redColor()
            $0.textLabel?.textAlignment = .Center
            }.onSelected {  [weak self](row) -> Void in
                
                self?.former.deselect(true)
//                
//                request(.GET, URL(.TOKEN))
//                    .responseString(completionHandler: { (res) -> Void in//token
//                        debugPrint(res)
//                    })
//                
        }
        
        
        let section  = SectionFormer(rowFormer: event_name,time_setting,start_time,createButton)
        former.append(sectionFormer: section)
        
    }
    
    func time_setting_changed (idx:Int , str:String) -> Void {
        if idx == 0 {//本日のみ
            former.removeUpdate(rowFormers:[end_time], rowAnimation: UITableViewRowAnimation.Left )
        }else{
            former.insertUpdate(rowFormers: [end_time], toIndexPath: NSIndexPath(forRow: 3, inSection: 0))
        }
    }
    
    lazy var end_time : InlineDatePickerRowFormer<FormInlineDatePickerCell> = {

        let res = InlineDatePickerRowFormer<FormInlineDatePickerCell>(){
            $0.titleLabel.text = "終了時間"
        }
        return res
    }()

    let start_time = InlineDatePickerRowFormer<FormInlineDatePickerCell>(){
        $0.titleLabel.text = "開始時間"
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
