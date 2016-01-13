//
//  Detector.m
//  PhotoShare
//
//  Created by 4423 on 2015/11/23.
//  Copyright © 2015年 ie4a. All rights reserved.
//
#import "PhotoShare-Bridging-Header.h"
#import <opencv2/opencv.hpp>
#import <opencv2/highgui/ios.h>

@interface Detector()
{
    cv::CascadeClassifier cascade;
}
@end

@implementation Detector : NSObject

- (id)init {
    self = [super init];
    
    // 分類器の読み込み
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
    std::string cascadeName = (char *)[path UTF8String];
    
    if(!cascade.load(cascadeName)) {
        return nil;
    }
    
    return self;
}

- (UIImage *)makegrayImage:(UIImage *)image {
    //カラー画像を読み込む
    cv::Mat mat;
    
    UIImageToMat(image,mat);
    cv::Mat color_img = mat;
    cv::Mat gray_img;
    
    // グレースケールに変換する
    cvtColor(color_img, gray_img,CV_RGB2GRAY);
    
    // cv::Mat -> UIImage変換
    UIImage *resultImage = MatToUIImage(color_img);
    
    return resultImage;
    
    
}

@end