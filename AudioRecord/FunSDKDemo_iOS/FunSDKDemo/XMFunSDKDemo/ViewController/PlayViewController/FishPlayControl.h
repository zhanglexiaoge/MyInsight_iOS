//
//  FishPlayControl.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/21.
//  Copyright © 2018年 XM. All rights reserved.
//
/*****
 *
 * 鱼眼视频预览视图控制器
*
 *****/
#import <Foundation/Foundation.h>
#import "VRGLViewController.h"
#import "HardVRViewController.h"
#import "UILabelOutLined.h"
#import "VRFunctionView.h"

@interface FishPlayControl : NSObject <VRFunctionViewDelegate>
{
    VRGLViewController *softV;//鱼眼软解播放画面，（绝大部分设备都是软解）
    HardVRViewController *hardV; //鱼眼硬解播放画面
    int Hardandsofts;//鱼眼解码模式 4:软解 3:硬解
    int Hardmodels;//鱼眼画面模式
    int shapeType; //吸顶模式还是壁挂模式
    BOOL isFeyeYuv;//是否是鱼眼预览
    short centerOffsetX; //鱼眼偏移量参数
    short centerOffsetY;
    short imageWidth; //语言宽高参数
    short imageHeight;
    short imgradius; //鱼眼半径参数
    UILabelOutLined *timeLab;
    UILabelOutLined *nameLab;
    
    UIButton *VRFunction;       //鱼眼显示形状功能 functionView  的button
    VRFunctionView *functionView;   //鱼眼显示形状功能view
}
#pragma mark 取出初始化成功的硬解或者软解控制器，传递给上层设置为childCiewController
- (GLKViewController *)getFeyeViewController ;
#pragma mark 初始化鱼眼播放界面
-(void)createFeye:(int)type frameSize:(CGRect)frame;
#pragma mark 根据鱼眼模式刷新界面
- (void)refreshSoftModel:(int)Hardandsoft model:(int)Hardmodel;
#pragma mark 接收到视频数据传递给底层处理显示画面
-(void)PushData:(int)width height:(int)height YUVData:(unsigned char *)pData;

#pragma mark 鱼眼软解，设置宽高中心偏移量半径等等参数
-(void)centerOffSetX:(short)OffSetx offY:(short)OffSetY  radius:(short)radius width:(short)width height:(short)height ;
#pragma mark 设置鱼眼视频预览的时间
- (void)setTimeLabelText:(NSString*)time;
@end
