//
//  EncodeItemViewController.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/6.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncodeItemViewController : UIViewController

@property (nonatomic, copy) void (^itemSelectStringBlock)(NSString *encodeStr); //字符串回调

- (void)setValueArray:(NSMutableArray *)array; //设置当前界面需要显示的内容
@end
