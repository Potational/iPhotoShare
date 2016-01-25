//
//  RegistViewController.swift
//  PhotoShare
//
//  Created by ZEmac on 2016/01/20.
//  Copyright © 2016年 ie4a. All rights reserved.
//

import UIKit
import Eureka

class RegistViewController: UIViewController ,UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "REGISTER"
        
        let req = NSURLRequest(URL: NSURL(string: URL("auth/register"))!)
        webView.delegate = self
        webView.loadRequest(req)
        
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        SwiftNotice.wait([loaderImage!], timeInterval: 0)
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        SwiftNotice.clear()
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
