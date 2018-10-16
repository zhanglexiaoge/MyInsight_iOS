//
//  PortraitScreenVC.m
//  MyInsight
//
//  Created by SongMenglong on 2017/12/2.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "PortraitScreenVC.h"
#import <Masonry.h>
#import "LandscapeScreenVC.h" // 横屏

@interface PortraitScreenVC ()

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation PortraitScreenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // 竖屏
    self.title = @"竖屏";
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.nextButton];
    [self.nextButton setTitle:@"横屏页面" forState:UIControlStateNormal];
    self.nextButton.backgroundColor = [UIColor blueColor];
    [self.nextButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(1.0f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.50f);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.25f);
    }];
}

- (void)buttonAction:(UIButton *)button {
    LandscapeScreenVC *twoVC = [[LandscapeScreenVC alloc] init];
    
    UINavigationController *twoNavi = [[UINavigationController alloc] initWithRootViewController:twoVC];
    // 模态推出
    [self presentViewController:twoNavi animated:NO completion:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 另外的横竖屏切换
 
 //http://www.jianshu.com/p/5f5d46e674a7

 /注册一些通知,添加观察者 在APPDelegate中添加通知和以下方法,在需要全屏的界面强制全屏,需要勾选Targets->General->Deployment Info->Device Orientation->Landscape Left & Landscape Right
 // 代理文件的代码如下：
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 // Override point for customization after application launch.
 [self initializeTheNotificationCenter];
 return YES;
 }
 
 
 #pragma mark    注册一些通知,添加观察者 在APPDelegate中添加通知和以下方法,在需要全屏的界面强制全屏,需要勾选Targets->General->Deployment Info->Device Orientation->Landscape Left & Landscape Right
 
 - (void)initializeTheNotificationCenter
 {
 //在进入需要全屏的界面里面发送需要全屏的通知
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startFullScreen) name:@"startFullScreen" object:nil];//进入全屏
 
 //在退出需要全屏的界面里面发送退出全屏的通知
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endFullScreen) name:@"endFullScreen" object:nil];//退出全屏
 }
 
 #pragma mark 进入全屏
 -(void)startFullScreen
 {
 AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 appDelegate.allowRotation = YES;
 }
 
 #pragma mark    退出横屏
 -(void)endFullScreen
 {
 AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 appDelegate.allowRotation = NO;
 
 //强制归正：
 if ([[UIDevice currentDevice]   respondsToSelector:@selector(setOrientation:)]) {
 SEL selector =     NSSelectorFromString(@"setOrientation:");
 NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
 [invocation setSelector:selector];
 [invocation setTarget:[UIDevice currentDevice]];
 int val =UIInterfaceOrientationPortrait;
 [invocation setArgument:&val atIndex:2];
 [invocation invoke];
 }
 }
 
 #pragma mark    禁止横屏
 - (UIInterfaceOrientationMask )application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
 }

 
 
 //在需要横竖屏切换的控制器内代码如下：
 - (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"endFullScreen" object:nil];
 }
 
 */






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
