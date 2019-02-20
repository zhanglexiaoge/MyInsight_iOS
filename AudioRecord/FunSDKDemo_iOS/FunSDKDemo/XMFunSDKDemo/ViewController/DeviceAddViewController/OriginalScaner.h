//
//  OriginalScaner.h
//  未来家庭
//
//  Created by Megatron on 11/6/15.
//  Copyright © 2015 Megatron. All rights reserved.
//

#import <UIKit/UIKit.h>

// 二维码扫描界面
@interface OriginalScaner : UIViewController

@property (copy,nonatomic) void (^myScanerFinishedBlock)(NSString *code);
@property (copy,nonatomic) void (^myScanerQuitBlock)();

@end
