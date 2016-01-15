//
//  Created by Dicky Tsang on 26/6/14.
//  Copyright (c) 2014 Dicky Tsang. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func loadImage(urlString url: String, autoCache: Bool) {
        
        let url = NSURL(string: url)!
        
        self.loadImage(url,autoCache: true)
    }
    
    func loadImage(url: NSURL, autoCache: Bool) {
        let urlId = url.hash
        
        let fileHandler = FileController()
        
        let cacheDir = "cache/images/\(urlId)"
        let existFileData = fileHandler.readFile(cacheDir)
        
        if existFileData == nil {
            NSURLSession.sharedSession().dataTaskWithURL(url) {
                data , res, error in
                if error == nil && data != nil {
                    dispatch_async(dispatch_get_main_queue()) {
                        
                        self.image = UIImage(data: data!)
                        fileHandler.writeFile(cacheDir, fileContent: data!)
                    }
                }
                }.resume()
        } else {
            image = UIImage(data: existFileData!)
        }
    }
    
    private class FileController {
        func writeFile(fileDir: String, fileContent: NSData) -> Bool {
            let filePath = docDir(fileDir)
            
            return fileContent.writeToFile(filePath, atomically: true)
        }
        
        func readFile(fileDir: String) -> NSData? {
            let filePath = docDir(fileDir)
            if let fileHandler = NSFileHandle(forReadingAtPath: filePath) {
                let fileData = fileHandler.readDataToEndOfFile()
                fileHandler.closeFile()
                return fileData
            } else {
                return nil
            }
        }
        
        //        func mkdir(fileDir: String) -> Bool {
        //            return NSFileManager.defaultManager().createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil, error: nil)
        //        }
    }
}

