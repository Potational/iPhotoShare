//
//  Cache.swift
//  Cache
//
//  Created by Remi Robert on 12/10/14.
//  Copyright (c) 2014 remirobert. All rights reserved.
//

import UIKit

//extension String {
//    var md5: String! {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(Int(CC_MD5_DIGEST_LENGTH))
//        var hash = NSMutableString()
//
//        CC_MD5(str!, CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)), result)
//        for i in 0..<Int(CC_MD5_DIGEST_LENGTH) {
//            hash.appendFormat("%02x", result[i])
//        }
//
//        result.destroy()
//        return String(format: hash)
//    }
//}

class ImageDownloader :NSObject, NSURLConnectionDelegate, NSURLConnectionDataDelegate {
    
    private var dataImage: NSMutableData? = NSMutableData()
    private var blockCompletion: ((imageDownloaded: UIImage?) -> ())?
    private var pathImage: String?
    private var sizeImage: CGSize?
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        blockCompletion?(imageDownloaded: nil)
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.dataImage?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        guard self.dataImage != nil else {
            return
        }
        
        let image = UIImage(data: self.dataImage!)
        guard image != nil else {
            return
        }
        
        var imageDownloaded = UIImage(data: UIImageJPEGRepresentation(image!, 1)!)
        
        if let compressSizeImage = self.sizeImage {
            self.resizeImage(&imageDownloaded!, sizeImage: compressSizeImage)
        }
        
        NSFileManager.defaultManager().createFileAtPath(self.pathImage!, contents: self.dataImage, attributes: nil)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.blockCompletion?(imageDownloaded: imageDownloaded)
        }
        
    }
    
    private func resizeImage(inout imageDownloaded: UIImage, sizeImage: CGSize) {
        if imageDownloaded.size.width == sizeImage.width &&
            imageDownloaded.size.height == sizeImage.height {
                return Void()
        }
        
        UIGraphicsBeginImageContextWithOptions(self.sizeImage!, false, 0.0)
        imageDownloaded.drawInRect(CGRectMake(0, 0, sizeImage.width, sizeImage.height))
        
        imageDownloaded = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func createRequest(urlImage: String) {
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: urlImage)!)
        _ = NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
    
    private class func runDownloadImage(urlImage urlImage: String, sizeImage: CGSize?, completionBlock: ((image:UIImage?) -> ())) {
        let pathCacheDirectory = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory,
            NSSearchPathDomainMask.UserDomainMask, true) as [AnyObject])[0] as! String
        let pathPhoto = pathCacheDirectory.stringByAppendingString("/\(urlImage.hash)" )
        
        print(pathPhoto)
        
        if NSFileManager.defaultManager().fileExistsAtPath(pathPhoto) == true {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                completionBlock(image: UIImage(data: NSFileManager.defaultManager().contentsAtPath(pathPhoto)!))
            }
            return Void()
            
        }
        
        let dImage = ImageDownloader()
        
        dImage.sizeImage = sizeImage
        dImage.pathImage = pathPhoto
        dImage.blockCompletion = completionBlock
        dImage.createRequest(urlImage)
    }
    
    class func downloadImage(urlImage urlImage: String, completionBlock: ((imageDownloaded:UIImage?) -> ())) {
        runDownloadImage(urlImage: urlImage, sizeImage: nil, completionBlock: completionBlock)
    }
    
    class func downloadImageWithSize(urlImage urlImage: String, sizeImage:CGSize, completionBlock: ((imageDownloaded:UIImage?) -> ())) {
        runDownloadImage(urlImage: urlImage, sizeImage: sizeImage, completionBlock: completionBlock)
    }
}

extension UIImageView {
    func downloadImage(urlImage: String) {
        ImageDownloader.downloadImage(urlImage: urlImage) { (imageDownloaded) -> () in
            self.image = imageDownloaded
        }
    }
    
    func downloadImageWithSize(urlImage: String) {
        ImageDownloader.downloadImageWithSize(urlImage: urlImage, sizeImage:self.frame.size)
            { (imageDownloaded) -> () in
                self.image = imageDownloaded
        }
    }
}
