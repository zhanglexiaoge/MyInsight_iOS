//
//  OpenCVVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/2.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "OpenCVVC.h"

@interface OpenCVVC ()
// imageview1 图片1
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
// imageview2 图片2
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
// imageview3 图片3
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
// imageview4 图片4
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;

@end

@implementation OpenCVVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"OpenCV";
    
    // 创建图片1
    //[self creatImageView1];
    // 创建图片2
    [self creatImageView2];
    // 创建图片3
    [self creatImageView3];
    // 创建图片4
    [self creatImageView4];
}

// 使用opencv的sdk
#pragma mark 创建照片1
//- (void)creatImageView1 {
//    UIImage* image = [UIImage imageNamed:@"test3"];
//
//    // Convert UIImage* to cv::Mat
//    UIImageToMat(image, cvImage);
//
////    if (/* DISABLES CODE */ (0)) {
////        NSString* filePath = [[NSBundle mainBundle]
////                              pathForResource:@"test3" ofType:@"png"];
////        // Create file handle
////        NSFileHandle* handle =
////        [NSFileHandle fileHandleForReadingAtPath:filePath];
////        // Read content of the file
////        NSData* data = [handle readDataToEndOfFile];
////        // Decode image from the data buffer
////        cvImage = cv::imdecode(cv::Mat(1, [data length], CV_8UC1,
////                                       (void*)data.bytes),
////                               CV_LOAD_IMAGE_UNCHANGED);
////    }
//
////    if (0) {
////        NSData* data = UIImagePNGRepresentation(image);
////        // Decode image from the data buffer
////        cvImage = cv::imdecode(cv::Mat(1, [data length], CV_8UC1,
////                                       (void*)data.bytes),
////                               CV_LOAD_IMAGE_UNCHANGED);
////    }
//
//    if (!cvImage.empty()) {
//        cv::Mat gray;
//        // Convert the image to grayscale
//        cv::cvtColor(cvImage, gray, CV_RGBA2GRAY);
//        // Apply Gaussian filter to remove small edges
//        cv::GaussianBlur(gray, gray,
//                         cv::Size(5, 5), 1.5, 1.5);
//        // Calculate edges with Canny
//        cv::Mat edges;
//        cv::Canny(gray, edges, 0, 50);
//        // Fill image with white color
//        cvImage.setTo(cv::Scalar::all(255));
//        // Change color on edges
//        cvImage.setTo(cv::Scalar(0, 128, 255, 255), edges);
//        // Convert cv::Mat to UIImage* and show the resulting image
//        self.imageView1.image = MatToUIImage(cvImage);
//    }
//}

#pragma mark 创建照片2
- (void)creatImageView2 {
    self.imageView2.image = [UIImage imageNamed:@"test3"];
}

#pragma mark 创建照片3
- (void)creatImageView3 {
    self.imageView3.image = [UIImage imageNamed:@"test3"];
}

#pragma mark 创建照片4
- (void)creatImageView4 {
    self.imageView4.image = [UIImage imageNamed:@"test3"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
