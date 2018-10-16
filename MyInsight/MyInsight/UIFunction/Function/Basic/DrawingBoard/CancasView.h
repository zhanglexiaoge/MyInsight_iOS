//
//  CancasView.h
//  MyInsight
//
//  Created by SongMengLong on 2018/6/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancasModel.h"

@interface CancasView : UIView

/** model */
@property (nonatomic,strong) CancasModel *model;

/** 存储path的可变数组索引 */
@property (nonatomic,strong)NSMutableArray *array;

/** 存储撤销的path的可变数组索引 */
@property (nonatomic,strong)NSMutableArray *replayArray;


/** 是否使用橡皮 */
@property (nonatomic,assign,getter=isRubber)BOOL rubber;

-(void)clear;

@end
