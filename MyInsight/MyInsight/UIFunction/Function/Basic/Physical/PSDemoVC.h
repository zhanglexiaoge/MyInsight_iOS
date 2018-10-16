//
//  PSDemoVC.h
//  MyInsight
//
//  Created by SongMenglong on 2018/4/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

typedef enum {
    FunctionSnap = 0,
    FunctionPush,
    FunctionAttachment,
    FunctionSpring,
    FunctionCollision
} PhysicalFunction;


@interface PSDemoVC : BaseVC

@property (nonatomic, assign) PhysicalFunction function;

@end
