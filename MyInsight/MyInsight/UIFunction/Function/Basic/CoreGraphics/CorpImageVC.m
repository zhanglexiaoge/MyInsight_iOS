
//
//  CorpImageVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CorpImageVC.h"
#import "UIColor+Category.h"
#import <Masonry.h>

@interface CorpImageVC ()

@end

@implementation CorpImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"裁剪图片";
    
    // 0.加载图片
    UIImage *image = [UIImage imageNamed:@"卡哇伊.jpg"];
    
    self.redView.layer.contents = (__bridge id _Nullable)([CorpImageVC imageWithClipImage:image borderWidth:3 borderColor:[UIColor RandomColor]].CGImage);
}

- (void)clipImage {
    // 0.加载图片
    UIImage *image = [UIImage imageNamed:@"卡哇伊.jpg"];
    // 1.开启位图上下文，跟图片尺寸一样大
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    // 2.设置圆形裁剪区域，正切与图片
    // 2.1创建圆形的路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    // 2.2把路径设置为裁剪区域
    [path addClip];
    // 3.绘制图片
    [image drawAtPoint:CGPointZero];
    // 4.从上下文中获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    
    self.redView.layer.contents = (__bridge id _Nullable)(clipImage.CGImage);
}


+ (UIImage *)imageWithClipImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)color {
    // 图片的宽度和高度
    CGFloat imageWH = image.size.width;
    // 设置圆环的宽度
    CGFloat border = borderWidth;
    // 圆形的宽度和高度
    CGFloat ovalWH = imageWH + 2 * border;
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(ovalWH, ovalWH), NO, 0);
    // 2.画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, ovalWH, ovalWH)];
    [color set];
    [path fill];
    // 3.设置裁剪区域
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(border, border, imageWH, imageWH)];
    [clipPath addClip];
    // 4.绘制图片
    [image drawAtPoint:CGPointMake(border, border)];
    // 5.获取图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();
    
    return clipImage;
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
