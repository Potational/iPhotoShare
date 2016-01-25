//
//  DownloadViewController.swift
//  PhotoShare
//
//  Created by 4423 on 2015/10/14.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit

let downloadCell = "downloadCell"

class DownloadViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var downloadtableView: UITableView!
    
    var events : JSON = nil
    var selectedEventId : String = ""
    var sel_event : JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadTableData()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        
    }
    
    func reloadTableData(){
        
        mgr.request(.GET, URL("events"))
            .responseJSON {
                [weak self] (res) -> Void in
                
                if let err = res.result.error {
                    self?.alert(err.description, message: nil)
                    return
                    
                }
                self?.events = JSON(res.result.value ?? [])
                print(self?.events)
                
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self?.downloadtableView.reloadData()
                })
                
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(downloadCell, forIndexPath: indexPath)  as! DownloadTableViewCell
        
        cell.nameLabel.text = events[indexPath.row]["event_name"].string
        return cell
    }
    
    
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        sel_event = events[indexPath.row]
        
        self.selectedEventId = events[indexPath.row]["id"].string!
        performSegueWithIdentifier("toPhotoStream",sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "toPhotoStream") {
            let downloadDetailView =  (segue.destinationViewController as! PhotoStreamViewController)
            downloadDetailView.event = sel_event
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
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
