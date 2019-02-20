//
//  PasswordConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/17.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "PasswordConfig.h"
#import "ModifyPassword.h"

@interface PasswordConfig()
{
}
@end
@implementation PasswordConfig


#pragma mark -  保存设备设备密码
- (void)changePassword:(NSString*)oldPsw newpassword:(NSString*)newPsw {
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //先设置原始密码
    signed char  oldChar[32] = {0};
    MD5Encrypt(oldChar,(unsigned char*)[oldPsw UTF8String]);
    //设置新密码
    signed char  newChar[32] = {0};
    MD5Encrypt(newChar,(unsigned char*)[newPsw UTF8String]);
    //拼装json
    NSDictionary* dictNewUserInfo = @{ @"UserName":channel.loginName, @"PassWord":[NSString stringWithUTF8String: (const char*)oldChar], @"NewPassWord":[NSString stringWithUTF8String: (const char*)newChar], @"EncryptType":@"MD5" };
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictNewUserInfo options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strValues = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //开始保存
    FUN_DevSetConfig_Json(self.msgHandle, SZSTR(channel.deviceMac), "ModifyPassword",
                          [strValues UTF8String],(int)[strValues length]+1);
}

#pragma mark 保存密码回调信息
-(void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    if (msg->id == EMSG_DEV_SET_CONFIG_JSON) {
        if ([self.delegate respondsToSelector:@selector(changePasswordConfigResult:)]) {
            [self.delegate changePasswordConfigResult:msg->param1];
        }
    }
}
void MD5Encrypt(signed char *strOutput, unsigned char *strInput);
@end
