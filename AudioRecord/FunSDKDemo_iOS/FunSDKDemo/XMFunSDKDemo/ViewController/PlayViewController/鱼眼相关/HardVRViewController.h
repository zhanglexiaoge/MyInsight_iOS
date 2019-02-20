//
//  HardVRViewController.h
//  XWorld
//
//  Created by Apple on 16/8/29.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import <CoreMotion/CMLogItem.h>
@protocol HardVrDelegate<NSObject>
-(void)HardVrsingle;
@end
@interface HardVRViewController : GLKViewController
@property (nonatomic,assign) int ZoomNumber;
-(void)PushData:(int)width height:(int)height YUVData:(unsigned char *)pData;
//滑动开始
-(void)HardTouchbegan:(CGPoint)BegPoint;

//huadong
-(void)HardTouchMove:(CGPoint)MovePoint;

//滑动结束
-(void)HardTouchEnd:(CGPoint)EndPoint;

//陀螺仪
-(void)HardoutputRotationData:(double)rotationX rotationY:(double)rotationY;

//是否全屏

//捏合手势
-(void)HardtouchesPinch:(CGFloat)Velocity;

//惯性滑动停止

-(void)MoveStop;

@end
