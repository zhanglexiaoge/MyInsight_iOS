//
//  NSData+AES.h
//  MyInsight
//
//  Created by SongMengLong on 2018/4/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)
//加密
- (NSData *) AES256_Encrypt:(NSString *)key;
//解密
- (NSData *) AES256_Decrypt:(NSString *)key;
//追加64编码
- (NSString *)newStringInBase64FromData;
//同上64编码
+ (NSString*)base64encode:(NSString*)str;

@end
