//
//  CAKeyFrameAnimationVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CAKeyFrameAnimationVC.h"
#import "UIColor+Category.h"

@interface CAKeyFrameAnimationVC ()

@end

@implementation CAKeyFrameAnimationVC

- (void)loadView {
    self.view = [[DrawView alloc] init];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关键帧动画CAKeyFrameA";
    
    //[MBProgressHUD showAutoMessage:@"手指移动画线"];
    self.blueLayer.bounds = CGRectMake(0, 0, 50, 50);
    
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


@interface DrawView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation DrawView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // touch
    UITouch *touch = [touches anyObject];
    // 获取手指的触摸点
    CGPoint curP = [touch locationInView:self];
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    _path = path;
    // 设置起点
    [path moveToPoint:curP];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // touch
    UITouch *touch = [touches anyObject];
    // 获取手指的触摸点
    CGPoint curP = [touch locationInView:self];
    [_path addLineToPoint:curP];
    
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    static BOOL isValue;
    // 给imageView添加核心动画
    // 添加核心动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.keyPath = @"position";
    // values
    
    if (isValue) {
        anim.values = @[@(100),@(-100),@(100)];
        isValue = NO;
    }else {
        // path
        anim.path = _path.CGPath;
        isValue = YES;
    }
    
    anim.duration = 3;
    anim.repeatCount = MAXFLOAT;

    // TODO：不会滑动了
    //[[(LMJCAKeyFrameAnimationViewController *)self.viewController blueLayer] addAnimation:anim forKey:nil];
    // 没实现该功能 该地方需要仔细研究demo去实现的原理
    if ([[self.superview nextResponder] isKindOfClass:[CAKeyFrameAnimationVC class]]) {
        [[(CAKeyFrameAnimationVC *)[self.superview nextResponder] blueLayer] addAnimation:anim forKey:nil];
    }
}

- (void)drawRect:(CGRect)rect {
    [[UIColor RandomColor] setStroke];
    
    [_path stroke];
}

@end



