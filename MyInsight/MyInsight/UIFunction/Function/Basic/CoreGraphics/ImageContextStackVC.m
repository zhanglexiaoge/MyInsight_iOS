//
//  ImageContextStackVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ImageContextStackVC.h"

@interface ImageContextStackVC ()

@end

@implementation ImageContextStackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图形上下文栈";
    
    [self redView];
}

- (Class)drawViewClass {
    return [ImageContextStackView class];
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

@implementation ImageContextStackView

// 如果以后用贝瑟尔绘制图形【path stroke】,上下文的状态由贝瑟尔路径状态
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2.描述路径
    // 第一根
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(10, 125)];
    
    [path addLineToPoint:CGPointMake(240, 125)];
    // 把路径添加到上下文
    // .CGPath 可以UIkit的路径转换成CoreGraphics路径
    CGContextAddPath(ctx, path.CGPath);
    // 保存一份上下文的状态
    CGContextSaveGState(ctx);
    // 设置上下文状态
    CGContextSetLineWidth(ctx, 10);
    [[UIColor redColor] set];
    // 渲染上下文
    CGContextStrokePath(ctx);
    // 第二根
    // 2.描述路径
    path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(125, 10)];
    
    [path addLineToPoint:CGPointMake(125, 240)];
    // 把路径添加到上下文
    // .CGPath 可以UIkit的路径转换成CoreGraphics路径
    CGContextAddPath(ctx, path.CGPath);
    // 还原状态
    CGContextRestoreGState(ctx);
    // 渲染上下文
    CGContextStrokePath(ctx);
}

@end

