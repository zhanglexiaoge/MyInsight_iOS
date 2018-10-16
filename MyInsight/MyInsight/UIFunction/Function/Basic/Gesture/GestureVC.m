
//
//  GestureVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/7.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "GestureVC.h"
#import "UIColor+Category.h"
#import <Masonry.h>

@interface GestureVC ()
// 测试Label
@property (nonatomic, strong) UILabel *testLabel;
// 测试View
@property (nonatomic, strong) UIView *testView;

@end

@implementation GestureVC
/*
 [iOS开发之手势事件(UiGestureRecognizer)](https://www.jianshu.com/p/4ac617c9493b)
 [iOS 手势操作：拖动、捏合、旋转、点按、长按、轻扫、自定义](https://www.cnblogs.com/huangjianwu/p/4675648.html)
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"手势";
    
    [self creatTestViews];
}

- (void)creatTestViews {
    self.testLabel = [[UILabel alloc] init];
    [self.view addSubview:self.testLabel];
    self.testLabel.backgroundColor = [UIColor RandomColor];
    self.testLabel.text = @"请点击下面的空白区";
    self.testLabel.textAlignment = NSTextAlignmentCenter;
    
    self.testView = [[UIView alloc] init];
    [self.view addSubview:self.testView];
    self.testView.backgroundColor = [UIColor RandomColor];
    
    // 代码约束布局
    [self.testLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64.0f+0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.height.offset(100.0f);
    }];
    
    [self.testView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.testLabel.mas_bottom).offset(0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0.0f);
    }];
    
    // 轻拍手势
    [self tapGestureView:self.testView];
    // 轻扫手势
    [self swipeGestureView:self.testView];
    // 长按手势
    [self longPressGestureView:self.testView];
    // 平移手势
    [self panGestureView:self.testView];
    // 屏幕边缘平移
    [self screenEdgePanGestureRecognizerView:self.testView];
    // 捏合手势缩放手势
    [self pinchGestureRecognizerView:self.testView];
    // 旋转手势
    [self rotationGestureRecognizerView:self.testView];
}

#pragma mark - 轻拍手势
- (void)tapGestureView:(UIView *)view {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tapGesture.numberOfTapsRequired = 1; //手指头个数
    tapGesture.numberOfTouchesRequired = 1; //
    
    [view addGestureRecognizer:tapGesture];
}

- (void)tapGestureAction:(UITapGestureRecognizer *)gesture {
    NSLog(@"轻拍手势");
    self.testLabel.text = @"轻拍手势";
    self.testView.backgroundColor = [UIColor RandomColor];
}

#pragma mark - 轻扫手势
- (void)swipeGestureView:(UIView *)view {
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    //设置属性，swipe也是有两种属性设置手指个数及轻扫方向
    swipeGesture.numberOfTouchesRequired = 1;
    //设置轻扫方向(默认是从左往右)
    //direction是一个枚举值有四个选项，我们可以设置从左往右，从右往左，从下往上以及从上往下
    //设置轻扫方向(默认是从左往右)
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp;
    
    [view addGestureRecognizer:swipeGesture];
}

- (void)swipeGestureAction:(UISwipeGestureRecognizer *)gesture {
    NSLog(@"轻扫手势");
    self.testLabel.text = @"轻扫手势";
    self.testView.backgroundColor = [UIColor RandomColor];
}

#pragma mark - 长按手势
- (void)longPressGestureView:(UIView *)view {
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureAction:)];
    //属性设置
    //最小长按时间
    longPressGesture.minimumPressDuration = 1;
    [view addGestureRecognizer:longPressGesture];
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按手势");
        self.testLabel.text = @"长按手势";
        self.testView.backgroundColor = [UIColor RandomColor];
    }
}

#pragma mark - 平移手势
- (void)panGestureView:(UIView *)view {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    
    [view addGestureRecognizer:panGesture];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    NSLog(@"平移手势");
    
//    CGPoint point = [gesture translationInView:_testView];
//    //sender.view.transform = CGAffineTransformMake(1, 0, 0, 1, point.x, point.y);
//
//    //平移一共两种移动方式
//    //第一种移动方法:每次移动都是从原来的位置移动
//    //sender.view.transform = CGAffineTransformMakeTranslation(point.x, point.y);
//
//    //第二种移动方式:以上次的位置为标准(移动方式 第二次移动加上第一次移动量)
//    gesture.view.transform = CGAffineTransformTranslate(gesture.view.transform, point.x, point.y);
//    //增量置为o
//    [gesture setTranslation:CGPointZero inView:gesture.view];
    
//    _testView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
    
    self.testLabel.text = @"平移手势";
    self.testView.backgroundColor = [UIColor RandomColor];
}

#pragma mark - 屏幕边缘平移
- (void)screenEdgePanGestureRecognizerView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenEdgePanGestureAction:)];
    
    //注意:,使用屏幕边界平移手势,需要注意两点
    //1. 视图位置(屏幕边缘)
    //2. 设置edges属性
    // 设置屏幕边缘手势支持方法
    screenEdgePanGesture.edges = UIRectEdgeLeft;
    //属性设置
    [view addGestureRecognizer:screenEdgePanGesture];
}

- (void)screenEdgePanGestureAction:(UIScreenEdgePanGestureRecognizer *)gesture {
    NSLog(@"屏幕边缘平移");
    self.testLabel.text = @"屏幕边缘平移";
    self.testView.backgroundColor = [UIColor RandomColor];
}

#pragma mark - 捏合手势
- (void)pinchGestureRecognizerView:(UIView *)view {
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureAction:)];
    [view addGestureRecognizer:pinchGesture];
    
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)gesture {
    NSLog(@"捏合手势");
    self.testLabel.text = @"捏合手势";
    self.testView.backgroundColor = [UIColor RandomColor];
}

#pragma mark - 旋转手势
- (void)rotationGestureRecognizerView:(UIView *)view {
    UIRotationGestureRecognizer *rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGestureAction:)];
    
    [view addGestureRecognizer:rotationGesture];
}

- (void)rotationGestureAction:(UIRotationGestureRecognizer *)gesture {
    NSLog(@"旋转手势");
    self.testLabel.text = @"旋转手势";
    self.testView.backgroundColor = [UIColor RandomColor];
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
