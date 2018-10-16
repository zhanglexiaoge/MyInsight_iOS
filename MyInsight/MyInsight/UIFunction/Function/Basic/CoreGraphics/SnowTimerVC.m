
//
//  SnowTimerVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "SnowTimerVC.h"

@interface SnowTimerVC ()

@end

@implementation SnowTimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下雪生成器";
    
    
    [self redView];
    self.redView.backgroundColor = [UIColor blackColor];
}

- (Class)drawViewClass {
    return [SnowTimerView class];
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


@interface SnowTimerView()
/** <#digest#> */
@property (weak, nonatomic) CADisplayLink *link;

@end

@implementation SnowTimerView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    // 如果以后想绘制东西到view上面，必须在drawRect方法里面，不管有没有手动获取到上下文
    // 修改雪花y值
    static CGFloat _snowY;
    UIImage *image =  [UIImage imageNamed:@"雪花.png"];
    [image drawAtPoint:CGPointMake(50, _snowY)];
    _snowY += 1;
    if (_snowY > rect.size.height) {
        _snowY = 0;
    }
}

// 如果在绘图的时候需要用到定时器，通常
// NSTimer很少用于绘图，因为调度优先级比较低，并不会准时调用
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUIOnce];
}

- (void)setupUIOnce {
    // 创建定时器
    //    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeChange) userInfo:nil repeats:YES];
    // CADisplayLink:每次屏幕刷新的时候就会调用，屏幕一般一秒刷新60次
  //  LMJWeak(self);
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(setNeedsDisplay)];
    // 添加主运行循环
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    _link = link;
}
- (void)dealloc {
    [_link invalidate];
    _link = nil;
}
@end


