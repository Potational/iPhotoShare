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
        
        reloadTableData()
        
        //        let myBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "onClickMyButton:")
        
        // Barの右に配置するボタンを配列に格納する.
        //        let myRightButtons: NSArray = [myBarButton]
        
        // NavigationBarを取得する.
        //        self.navigationController?.navigationBar
        
        // NavigationBarの表示する.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        // Barの右側に複数配置する.
        //        self.navigationItem.setRightBarButtonItems(myRightButtons as? [UIBarButtonItem], animated: true)
        
        
        // Do any additional setup after loading the view.
    }
    
    //    internal func onClickMyButton(sender: UIButton){
    //        let alertController = UIAlertController(title: "SHARE", message: "方法選択", preferredStyle: .ActionSheet)
    //        let firstAction = UIAlertAction(title: "QR CODE", style: .Default) {
    //            action in print("Pushed First")
    //        }
    //        let secondAction = UIAlertAction(title: "URL", style: .Default) {
    //            action in print("Pushed Second")
    //        }
    //        let cancelAction = UIAlertAction(title: "キャンセル", style: .Cancel) {
    //            action in print("Pushed CANCEL")
    //        }
    //
    //        alertController.addAction(firstAction)
    //        alertController.addAction(secondAction)
    //        alertController.addAction(cancelAction)
    //
    //        //For ipad And Univarsal Device
    //        alertController.popoverPresentationController?.sourceView = sender as UIView;
    //        alertController.popoverPresentationController?.sourceRect = CGRect(x: (sender.frame.width/2), y: sender.frame.height, width: 0, height: 0)
    //        alertController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.Up
    //
    //        presentViewController(alertController, animated: true, completion: nil)
    //    }
    
    //    override func viewWillAppear(animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //    }
    
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
                
                //                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self?.downloadtableView.reloadData()
                //                })
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
        //        print(events[indexPath.row]["event_name"].string)
        
        cell.nameLabel.text = events[indexPath.row]["event_name"].string
        return cell
    }
    
    var sel_event : JSON?
    
    func tableView(table: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        sel_event = events[indexPath.row]
        
        self.selectedEventId = events[indexPath.row]["id"].string!
        performSegueWithIdentifier("toPhotoStream",sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        if (segue.identifier == "toPhotoStream") {
            let downloadDetailView =  (segue.destinationViewController as! PhotoStreamViewController)
            //            print(self.selectedEventId)
            downloadDetailView.event = sel_event
            //            downloadDetailView.eventId = selectedEventId
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
