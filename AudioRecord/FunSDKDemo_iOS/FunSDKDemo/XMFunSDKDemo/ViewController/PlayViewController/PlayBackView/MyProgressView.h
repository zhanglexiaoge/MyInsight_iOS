//
//  MyProgressView.h
//  TEST
//
//  Created by Megatron on 12/1/14.
//  Copyright (c) 2014 Megatron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeInfo.h"
#import "VideoContentDefination.h"
@interface MyProgressView : UIView

@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) enum Unit_Type type;
@property (nonatomic,assign) int leftN;
@property (nonatomic,assign) int rightN;
@property (nonatomic,assign) int standardN;
@property (nonatomic,assign) float middleT;
@property (nonatomic,assign) int num;
@property (nonatomic,strong) NSMutableArray *array_Lab;

-(void)refreshViewWithDataFrom:(int)leftNum to:(int)rightNum andMiddleNum:(int)standardNum  andMiddleTime:(int)second andType:(enum Unit_Type)type;

@end
