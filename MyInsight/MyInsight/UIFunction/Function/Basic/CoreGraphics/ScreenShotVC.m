
//
//  ScreenShotVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ScreenShotVC.h"

@interface ScreenShotVC ()

@end

@implementation ScreenShotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"截屏";
    
    
    // 生成一张新的图片
    UIImage *image =  [ScreenShotVC imageWithCaputureView:[UIApplication sharedApplication].delegate.window];
    
    UIImageView *imv = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imv];
    imv.frame = CGRectMake(0, 80, 300, 500);
    
    // image转data
    // compressionQuality： 图片质量 1:最高质量
    //NSData *data = UIImageJPEGRepresentation(image,1);
    //[data writeToFile:@"/Users/huxupeng/Desktop/view.png" atomically:YES];
    
}

+ (UIImage *)imageWithCaputureView:(UIView *)view {
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0);
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 把控件上的图层渲染到上下文,layer只能渲染
    [view.layer renderInContext:ctx];
    // 生成一张图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
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
