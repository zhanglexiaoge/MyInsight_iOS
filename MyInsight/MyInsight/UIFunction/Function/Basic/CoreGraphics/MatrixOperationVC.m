
//
//  MatrixOperationVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "MatrixOperationVC.h"

@interface MatrixOperationVC ()

@end

@implementation MatrixOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"矩阵操作";
    
    [self redView];
}

- (Class)drawViewClass {
    return [MatrixOperatioView class];
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

@implementation MatrixOperatioView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 1.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 2.描述路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-100, -50, 200, 100)];
    
    [[UIColor redColor] set];
    
    // 上下文矩阵操作
    // 注意:矩阵操作必须要在添加路径之前=========
    //  平移
    CGContextTranslateCTM(ctx, 100, 50);
    // 缩放
    CGContextScaleCTM(ctx, 0.5, 0.5);
    // 旋转
    CGContextRotateCTM(ctx, M_PI_4);
    // 3.把路径添加上下文
    CGContextAddPath(ctx, path.CGPath);
    // 4.渲染上下文
    CGContextFillPath(ctx);
}


@end


