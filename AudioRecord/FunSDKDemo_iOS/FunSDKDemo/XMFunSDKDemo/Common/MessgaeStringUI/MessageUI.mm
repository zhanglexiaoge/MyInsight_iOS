//
//  MessageUI.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/9.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "MessageUI.h"

@implementation MessageUI

//显示传递的错误信息
+(void)ShowError:(NSString *) str{
    [MessageUI ShowError:str title:TS("Error_Warning")];
}
//显示传递的错误信息和标题
+(void)ShowError:(NSString *) str title:(NSString *)title{
    [SVProgressHUD showErrorWithStatus:str duration:3];
}

//格局传递的错误值int显示错误信息
+(void)ShowErrorInt:(int) errorno{
    [MessageUI ShowError:[MessageUI GetErrorStr:errorno]];
}
//根据传入的错误值和标题显示错误信息
+(void)ShowErrorInt:(int) errorno  title:(NSString *)title{
    [MessageUI ShowError:[MessageUI GetErrorStr:errorno] title:title];
}

//根据int值获取错误信息（例：-11301就是密码错误）
+(NSString *)GetErrorStr:(int)intError{
    NSString *intErr = [NSString stringWithFormat:@"%d", intError];
    //用plist文件取枚举值
    NSString *errorPath = [[NSBundle mainBundle] pathForResource:@"error.plist" ofType:nil];
    NSDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:errorPath];
    NSString *errorString = [data valueForKey:intErr];
    if ( !errorString ) {
        return [NSString stringWithFormat:@"%@[%d]", TS("Unknown_Error"), intError];
    }
    if ([TS([errorString UTF8String]) hasPrefix:@"EE_"]) {
        return [NSString stringWithFormat:@"%@[%@,%d]", TS("Unknown_Error"), errorString, intError];
    }
    return [NSString stringWithFormat:@"%@[%d]", TS([errorString UTF8String]), intError];
}
@end
