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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableData()
    }
    
    func reloadTableData(){
        
        mgr.request(.GET, URL("/events"))
            .responseJSON {[weak self] (res) -> Void in
                
                if let err = res.result.error {
                    self?.alert(err.description, message: nil)
                    return
                    
                }
                self?.events = JSON(res.result.value ?? [])
                print(self?.events)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self?.downloadtableView.reloadData()
                })
        }
        //        self.tableView.reloadData()
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
        print(events[indexPath.row]["event_name"].string)
        cell.nameLabel.text = events[indexPath.row]["event_name"].string
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        self.selectedEventId = events[indexPath.row]["id"].string!
        performSegueWithIdentifier("toDownloadDetail",sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "toDownloadDetail") {
            let downloadDetailView : DownloadDetailViewController =  (segue.destinationViewController as? DownloadDetailViewController)!
            print(self.selectedEventId)
            downloadDetailView.eventId = selectedEventId
        }
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
