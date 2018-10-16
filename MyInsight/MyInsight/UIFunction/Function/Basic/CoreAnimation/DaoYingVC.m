//
//  DaoYingVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "DaoYingVC.h"

@interface DaoYingVC ()

@property (weak, nonatomic) IBOutlet RepView *repView;

@end

@implementation DaoYingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"倒影";
    
    CAReplicatorLayer *layer =  (CAReplicatorLayer *)_repView.layer;
    
    layer.instanceCount = 2;
    
    CATransform3D transform = CATransform3DMakeTranslation(0, _repView.bounds.size.height, 0);
    // 绕着X轴旋转
    transform = CATransform3DRotate(transform, M_PI, 1, 0, 0);
    
    // 往下面平移控件的高度
    layer.instanceTransform = transform;
    
    layer.instanceAlphaOffset = -0.1;
    layer.instanceBlueOffset = -0.1;
    layer.instanceGreenOffset = -0.1;
    layer.instanceRedOffset = -0.1;
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

@implementation RepView

// 设置控件主层的类型
+ (Class)layerClass
{
    return [CAReplicatorLayer class];
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
