//
//  EventsTableViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2015/12/03.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import UIKit

let eventcell = "eventcell"

class EventsTableViewController: UITableViewController , UIViewControllerTransitioningDelegate {
    
    var events : JSON = nil
    var sel_event : JSON?
    var needShowPhotos : Bool = false
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerNib(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: eventcell)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        reloadTableData()
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
                //                print(self?.events)
                //                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self?.tableView.reloadData()
                //                })
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(eventcell, forIndexPath: indexPath) as! EventTableViewCell
        
        let event = events[indexPath.row]
        
        //event_name
        cell.event_name.text = event["event_name"].string
        //参加者
        cell.by.text = event["members"].string
        //QR image
        let imageUrl = URL("events/qr/") + event["id"].stringValue
        if event["uuid"].type == .Null  {//参加者はQRを出せない
            cell.qrButton.hidden = true
            cell.qrButton.setImage(nil, forState: .Normal)
            
        }else{
            ImageDownloader.downloadImage(urlImage: imageUrl) { (imageDownloaded) -> () in
                cell.qrButton.hidden = false
                cell.qrButton.setImage(imageDownloaded, forState: .Normal)
                
                cell.qrButton.addTapGesture(tapNumber: 1, action: {
                    [weak self](ges) -> () in
                    self?.qrButton = cell.qrButton
                    self?.event = event
                    
                    self?.qrZoom()
                    
                    })
            }
        }
        
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if needShowPhotos {
            sel_event = events[indexPath.row]
            performSegueWithIdentifier("toPhotoStream", sender: nil)
        }else {
            let event = events[indexPath.row]
            joinLink(event){
                json in
                goToCamera()
            }
        }
        
    }
    
    
    var qrButton : UIButton!
    var event : JSON!
    
    func qrZoom()
    {
        self.performSegueWithIdentifier("qrZoom", sender: nil)
    }
    
    let transition = BubbleTransition()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "qrZoom" {
            
            let qrVC = segue.destinationViewController as! QRZoomViewController
            qrVC.qrImage = qrButton.imageView?.image
            qrVC.event = self.event
            
            qrVC.transitioningDelegate = self
            qrVC.modalPresentationStyle = .Custom
        }
        
        if (segue.identifier == "toPhotoStream") {
            let downloadDetailView =  (segue.destinationViewController as! PhotoStreamViewController)
            downloadDetailView.event = sel_event
            
        }
        
        
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        //        transition.startingPoint = self.qrButton.center
        //                transition.bubbleColor = .blackColor()
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        //        transition.startingPoint = self.qrButton.center
        //                transition.bubbleColor = .blackColor()
        return transition
    }
    
    
}
