//
//  EncryptUtils.h
//  MyInsight
//
//  Created by SongMengLong on 2018/5/4.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptUtils : NSObject

+ (NSString*)getSysTimeStamp;
+ (NSString *)md5:(NSString *)str;

@end
