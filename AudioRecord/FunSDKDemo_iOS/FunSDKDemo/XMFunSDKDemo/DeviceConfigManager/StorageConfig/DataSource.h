//
//  DataSource.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/18.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

#pragma mark - 获取开关字符串
-(NSString *)getEnableString:(BOOL)enable;
#pragma mark  获取开关BOOL值
-(BOOL)getEnableBool:(NSString *)enableStr;

@end
