//
//  Student.h
//  MyInsight
//
//  Created by SongMengLong on 2018/9/15.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Student : NSObject

// 学号
@property (nonatomic, assign) int id;
// 姓名
@property (nonatomic, strong) NSString *name;
// 性别
@property (nonatomic, strong) NSString *sex;
// 年龄
@property (nonatomic, assign) int age;

@end
