//
//  CALayerBaseVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CALayerBaseVC.h"
#import "UIColor+Category.h"

@interface CALayerBaseVC ()

@end

@implementation CALayerBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置阴影
    // Opacity：不透明度
    self.redView.layer.shadowOpacity = 0.6;
    self.redView.layer.shadowOffset = CGSizeMake(3, 3);
    
    // 注意：图层的颜色都是核心绘图框架，通常。CGColor
    self.redView.layer.shadowColor = [UIColor RandomColor].CGColor;
    self.redView.layer.shadowRadius = 10;
    
    // 圆角半径
    self.redView.layer.cornerRadius = 50;
    
    // 边框
    self.redView.layer.borderWidth = 2;
    self.redView.layer.borderColor = [UIColor RandomColor].CGColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点点点 点击");
    // 图层形变
    // 缩放
    [UIView animateWithDuration:1 animations:^{
        //self.redView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
        //self.redView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1);
        CATransform3D transform = CATransform3DMakeRotation(M_PI, 1, 1, 0);
        // 叠加
        self.redView.layer.transform = CATransform3DScale(transform, 0.5, 0.5, 1);
        
        // 快速进行图层缩放,KVC
        // x,y同时缩放0.5
        // [self.redView.layer setValue:@0.5 forKeyPath:@"transform.scale"];
        // [self.redView.layer setValue:@(M_PI) forKeyPath:@"transform.rotation"];
    } completion:^(BOOL finished) {
        
        self.redView.layer.transform = CATransform3DIdentity;
    }];
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
