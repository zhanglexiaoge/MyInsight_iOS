//
//  EncodingFormatViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/17.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "EncodingFormatViewController.h"

@interface EncodingFormatViewController ()

@end

@implementation EncodingFormatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviStyle];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("Encoding_format");
}

@end
