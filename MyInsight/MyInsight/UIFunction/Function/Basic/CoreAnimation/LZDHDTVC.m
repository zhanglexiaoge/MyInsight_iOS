//
//  LZDHDTVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "LZDHDTVC.h"

@interface LZDHDTVC ()

@end

@implementation LZDHDTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"粒子动画单条";
}

- (IBAction)startAni:(UIButton *)sender {
    LZDHDTDrawView *view = (LZDHDTDrawView *)self.view;
    [view startAnim];
}

- (IBAction)reDraw:(UIButton *)sender {
    LZDHDTDrawView *view = (LZDHDTDrawView *)self.view;
    [view reDraw];
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

@interface LZDHDTDrawView ()

@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, weak) CALayer *dotLayer;

@property (nonatomic, weak) CAReplicatorLayer *repL;

@end

@implementation LZDHDTDrawView

static int _instansCount = 0;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 重绘
    [self reDraw];
    
    // 获取touch对象
    UITouch *touch = [touches anyObject];
    
    // 获取当前触摸点
    CGPoint curP = [touch locationInView:self];
    
    // 创建一个路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    // 设置起点
    [path moveToPoint:curP];
    
    _path = path;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // 获取touch对象
    UITouch *touch = [touches anyObject];
    
    // 获取当前触摸点
    CGPoint curP = [touch locationInView:self];
    
    // 添加线到某个点
    [_path addLineToPoint:curP];
    
    // 重绘
    [self setNeedsDisplay];
    
    _instansCount ++;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [_path stroke];
}

#pragma mark - 开始动画
- (void)startAnim {
    [_dotLayer removeAnimationForKey:@"CAKeyframeAnimation"];
    
    _dotLayer.hidden = NO;
    
    // 创建帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.keyPath = @"position";
    
    anim.path = _path.CGPath;
    
    anim.duration = 4;
    
    anim.repeatCount = MAXFLOAT;
    
    [_dotLayer addAnimation:anim forKey:@"CAKeyframeAnimation"];
    
    // 复制子层
    _repL.instanceCount = _instansCount;
    
    _repL.instanceDelay = 0.1;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 创建复制层
    CAReplicatorLayer *repL = [CAReplicatorLayer layer];
    
    repL.frame = self.bounds;
    
    [self.layer addSublayer:repL];
    
    // 创建图层
    CALayer *layer = [CALayer layer];
    
    CGFloat wh = 10;
    layer.frame = CGRectMake(0, -1000, wh, wh);
    
    layer.cornerRadius = wh / 2;
    
    layer.backgroundColor = [UIColor blueColor].CGColor;
    
    [repL addSublayer:layer];
    
    _dotLayer = layer;
    
    _repL = repL;
}

- (void)reDraw {
    _path = nil;
    _instansCount = 0;
    _dotLayer.hidden = YES;
    [self setNeedsDisplay];
}

@end

