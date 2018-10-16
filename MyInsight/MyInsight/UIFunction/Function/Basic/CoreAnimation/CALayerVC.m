//
//  CALayerVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CALayerVC.h"

@interface CALayerVC ()

@end

@implementation CALayerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (UIView *)redView {
    if (!_redView) {
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 150, 200)];
        [self.view addSubview:redView];
        _redView = redView;
        redView.backgroundColor = [UIColor redColor];
    }
    return _redView;
}

- (CALayer *)blueLayer {
    if (!_blueLayer) {
        CALayer *blueLayer = [CALayer layer];
        [self.view.layer addSublayer:blueLayer];
        blueLayer.backgroundColor = [UIColor blueColor].CGColor;
        _blueLayer = blueLayer;
        blueLayer.frame = CGRectMake(50, 350, 100, 70);
    }
    return _blueLayer;
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
