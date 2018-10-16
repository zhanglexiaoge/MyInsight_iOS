//
//  NSString+AES.h
//  MyInsight
//
//  Created by SongMengLong on 2018/4/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+AES.h"

@interface NSString (AES)

//加密
- (NSString *) AES256_Encrypt:(NSString *)key;
//解密
- (NSString *) AES256_Decrypt:(NSString *)key;

@end
