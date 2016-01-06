//
//  CameraUtil.swift
//  PhotoShare
//
//  Created by 4423 on 2015/11/23.
//  Copyright © 2015年 ie4a. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class CameraUtil{
    
    class func imageFromSampleBuffer(sampleBuffer: CMSampleBufferRef) ->UIImage {
        let imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        //ベースアドレスのロック
        CVPixelBufferLockBaseAddress(imageBuffer, 0)
        
        //画像データ情報取得
        let baseAddress: UnsafeMutablePointer<Void> = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, Int(0))
        
        let bytesPerRow:Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width: Int = CVPixelBufferGetWidth(imageBuffer)
        let height: Int = CVPixelBufferGetHeight(imageBuffer)
        
        let colorSpace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
        
        let bitsPerCompornent: Int = 8
        let bitmapInfo = CGBitmapInfo(rawValue: (CGBitmapInfo.ByteOrder32Little.rawValue | CGImageAlphaInfo.PremultipliedFirst.rawValue) as UInt32)
        let newContext: CGContextRef = CGBitmapContextCreate(baseAddress, width, height, bitsPerCompornent, bytesPerRow, colorSpace, bitmapInfo.rawValue)! as CGContextRef
        
        let imageRef: CGImageRef = CGBitmapContextCreateImage(newContext)!
        
        let resultImage: UIImage = UIImage(CGImage: imageRef)
        return resultImage
    }
    
    
}
