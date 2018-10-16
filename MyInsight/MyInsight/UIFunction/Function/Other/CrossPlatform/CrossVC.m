//
//  CrossVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/9/19.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CrossVC.h"
//#import <WXDevtool/WXDevtool.h>
#import <WXDevTool.h>
#import <WXAppConfiguration.h>
#import <WXSDKEngine.h>

@interface CrossVC ()

@end

@implementation CrossVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // http://weex.apache.org/cn/guide/integrate-devtool-to-ios.html
    self.title = @"跨平台Weex";
    
    //[WXDevTool setDebug:YES];
    //[WXDevTool launchDevToolDebugWithUrl:@"ws://30.30.31.7:8088/debugProxy/native"];
    
    [self initWeexSDK];
    
    
}

- (void)initWeexSDK {
    
    
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
