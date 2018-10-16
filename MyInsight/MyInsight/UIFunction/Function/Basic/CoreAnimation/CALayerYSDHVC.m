//
//  CALayerYSDHVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CALayerYSDHVC.h"
#import "UIColor+Category.h"

#define angle2radion(angle) ((angle) / 180.0 * M_PI)

@interface CALayerYSDHVC ()

@end

@implementation CALayerYSDHVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.blueLayer.position = CGPointMake(200, 150);
    
    self.blueLayer.anchorPoint = CGPointZero;
    
    self.blueLayer.bounds = CGRectMake(0, 0, 80, 80);
    
    self.blueLayer.backgroundColor = [UIColor greenColor].CGColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
    // 旋转
    self.blueLayer.transform = CATransform3DMakeRotation(angle2radion(arc4random_uniform(360) + 1), 0, 0, 1);
    self.blueLayer.position = CGPointMake(arc4random_uniform(200) + 20, arc4random_uniform(400) + 50);
    self.blueLayer.cornerRadius = arc4random_uniform(50);
    self.blueLayer.backgroundColor = [UIColor RandomColor].CGColor;
    self.blueLayer.borderWidth = arc4random_uniform(10);
    self.blueLayer.borderColor = [UIColor RandomColor].CGColor;
    
    
//    [UIAlertController mj_showAlertWithTitle:@"隐式动画的frame " message:[NSString stringWithFormat:@"self.redView.frame = %@", NSStringFromCGRect(self.blueLayer.frame)]  appearanceProcess:^(JXTAlertController * _Nonnull alertMaker) {
//
//        alertMaker.addActionDefaultTitle(@"确认");
//
//    } actionsBlock:nil];
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
