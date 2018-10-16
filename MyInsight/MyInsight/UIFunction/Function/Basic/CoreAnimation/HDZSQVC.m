//
//  HDZSQVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "HDZSQVC.h"

@interface HDZSQVC ()

@end

@implementation HDZSQVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动指示器";
    
    self.redView.frame = CGRectMake(20, 100, 250, 250);
    self.redView.backgroundColor = [UIColor grayColor];
    
    
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
    
    repL.frame = self.redView.bounds;
    
    [self.redView.layer addSublayer:repL];
    
    
    CALayer *layer = [CALayer layer];
    
    layer.transform = CATransform3DMakeScale(0, 0, 0);
    
    layer.position = CGPointMake(self.redView.bounds.size.width / 2, 20);
    
    layer.bounds = CGRectMake(0, 0, 10, 10);
    
    layer.backgroundColor = [UIColor greenColor].CGColor;
    
    
    [repL addSublayer:layer];
    
    // 设置缩放动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    anim.keyPath = @"transform.scale";
    
    anim.fromValue = @1;
    
    anim.toValue = @0;
    
    anim.repeatCount = MAXFLOAT;
    
    CGFloat duration = 1;
    
    anim.duration = duration;
    
    [layer addAnimation:anim forKey:nil];
    
    
    int count = 20;
    
    CGFloat angle = M_PI * 2 / count;
    
    // 设置子层总数
    repL.instanceCount = count;
    
    repL.instanceTransform = CATransform3DMakeRotation(angle, 0, 0, 1);
    
    repL.instanceDelay = duration / count;
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
