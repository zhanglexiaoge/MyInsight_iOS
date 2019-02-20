//
//  FishPlayControl.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/21.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "FishPlayControl.h"
#import "FunSDK/FunSDK.h"

@implementation FishPlayControl
#pragma mark 回调设置一些鱼眼参数,Hardandsoft鱼眼解码模式，Hardmodel画面模式
- (void)refreshSoftModel:(int)Hardandsoft model:(int)Hardmodel {
    if(Hardandsoft == 3) {
        if (Hardmodel == SDK_FISHEYE_SECENE_P360_FE) {
            hardV.view.hidden = NO;
            Hardmodels =Hardmodel;
            Hardandsofts =Hardandsoft;
        }else if(Hardmodel == SDK_FISHEYE_SECENE_RRRR_R){
            hardV.view.hidden = YES;
            Hardmodels =Hardmodel;
            Hardandsofts =Hardandsoft;
        }
        [softV removeFromParentViewController];
        //保存鱼眼状态
        //[Config saveFisheye:[self getLocalKey] mode:Hardmodel];
        //        增加鱼眼手势
        //        if (twoFingerPinch == nil) {
        //            twoFingerPinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(touchesPinch:)];
        //            [self.view addGestureRecognizer:twoFingerPinch];
        //        }
        isFeyeYuv = YES;
    }
    else if(Hardandsoft ==4) {
        [self VRSoftSetFecParams];
        //创建模式切换界面
        [self createVRFunctionView:Hardmodel];
        Hardmodels =Hardmodel;
        Hardandsofts =Hardandsoft;
        if (Hardmodel == 0) {
            [softV setVRType:XMVR_TYPE_360D];
        }else{
            [softV setVRType:XMVR_TYPE_180D];
        }
        softV.view.hidden = NO;
        [softV configSoftEAGLContext];
        //保存鱼眼模式
        // [Config saveFisheye:[self getLocalKey] mode:Hardmodel];
        isFeyeYuv = YES;
    } else if(Hardandsoft ==5){
        Hardmodels =Hardmodel;
        Hardandsofts =Hardandsoft;
        [softV setVRType:XMVR_TYPE_SPE_CAM01];
        [self VRSoftSetFecParams];
        softV.view.hidden = NO;
    }
}

#pragma mark 鱼眼软解 设置宽高中心偏移量半径等等参数
-(void)centerOffSetX:(short)OffSetx offY:(short)OffSetY  radius:(short)radius width:(short)width height:(short)height {
    centerOffsetX = OffSetx;
    centerOffsetY = OffSetY;
    imgradius = radius;
    imageWidth = width;
    imageHeight = height;
}
#pragma mark 刷新鱼眼界面宽高中心点以及偏移量
-(void)VRSoftSetFecParams {
    [softV setVRFecParams:centerOffsetX yCenter:centerOffsetY radius:imgradius Width:imageWidth Height:imageHeight];
}
#pragma mark 接收到视频数据传递给底层处理显示画面
-(void)PushData:(int)width height:(int)height YUVData:(unsigned char *)pData {
    if (hardV && hardV.view.hidden == NO) {
        [hardV PushData:width height:height YUVData:pData];
    }else if (softV && softV.view.hidden == NO) {
        [softV PushData:width height:height YUVData:pData];
    }
}
#pragma mark 设置鱼眼视频预览的时间
- (void)setTimeLabelText:(NSString*)time {
    timeLab.text = time;
}
#pragma mark 初始化鱼眼播放界面
-(void)createFeye:(int)type frameSize:(CGRect)frame{
    CGRect rect = frame;
    rect.origin.x=0;
    rect.origin.y=0;
    if (type == 3) {
        if (hardV == nil) {
            hardV = [[HardVRViewController alloc] init];
            hardV.view.frame = rect;
            hardV.view.hidden = YES;
            [hardV.view addSubview:self.timeLab];
            [hardV.view addSubview:self.nameLab];
        }
    }
    else if (type == 4 || type == 5)     {
        if (softV == nil) {
            softV = [[VRGLViewController alloc] init];
            softV.view.frame = rect;
            softV.view.hidden = YES;
            [softV.view addSubview:self.timeLab];
            [softV.view addSubview:self.nameLab];
        }
    }
}

- (GLKViewController *)getFeyeViewController {
    if (softV != nil) {
        return softV;
    }
    return hardV;
}

- (UILabelOutLined*)timeLab {
    if (timeLab == nil) {
        timeLab = [[UILabelOutLined alloc] initWithFrame:CGRectMake(ScreenWidth-160 , 0, 150, 30)];
        timeLab.textAlignment = NSTextAlignmentRight;
    }
    return timeLab;
}

- (UILabelOutLined*)nameLab {
    if (nameLab == nil) {
        nameLab = [[UILabelOutLined alloc] initWithFrame:CGRectMake(10 , 0, 150, 30)];
        nameLab.textAlignment = NSTextAlignmentLeft;
    }
    return nameLab;
}

#pragma mark 创建切换鱼眼画面模式的功能界面
-(void)createVRFunctionView:(int)Hardmodel {
    int VRHeight = 72;
    if (Hardmodel) {//180VR
        VRHeight = 40;
    }else{//360VR
        VRHeight = 72;
    }
    //这个判断保证只生成一个VRFunction button
    if (VRFunction == nil) {
        UIView *posintionView = [[UIView alloc]initWithFrame:CGRectMake(0, realPlayViewHeight - VRHeight,30*1.5,VRHeight)];
        posintionView.backgroundColor =[UIColor clearColor];
        [softV.view addSubview:posintionView];
        VRFunction = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
        VRFunction.center = posintionView.center;
        [VRFunction setImage:[UIImage imageNamed:@"360VR-ins_default.png"] forState:UIControlStateNormal];
        [VRFunction addTarget:self action:@selector(ShowVRFunctionView) forControlEvents:UIControlEventTouchUpInside];
        [softV.view addSubview:VRFunction];
        softV.VRShowMode = 1;//1代表吸顶(ceiling)模式 0代表壁挂(wall)  每次第一次进入 默认都 吸顶加 shape_ball 球模式(360VR默认)
        CGRect rect = CGRectMake(0, realPlayViewHeight - VRHeight, ScreenWidth,VRHeight);
        functionView = [[VRFunctionView alloc]initWithFrame:rect VRType:Hardmodel];
        [functionView.closeMode addTarget:self action:@selector(closeFunctionViewAndShowFunctionVRButton) forControlEvents:UIControlEventTouchUpInside];
        functionView.ceiling.selected = YES;
        functionView.Ball.selected = YES;
        functionView.delegate = self;
    }
}
#pragma mark - 鱼眼VR模式切换代理方法
-(void)changeVRFunctionMode:(_XMVRShape)type WithWarOrCeiling:(int)model
{
    [softV setVRShowMode:model];
    [softV setVRShapeType:type];
}
//显示壁挂吸顶功能菜单
- (void)ShowVRFunctionView{
    VRFunction.hidden = YES;
    functionView.hidden = NO;
    [softV.view addSubview:functionView];
}

//关闭壁挂吸顶功能菜单 并显示功能按钮
- (void)closeFunctionViewAndShowFunctionVRButton{
    VRFunction.hidden = NO;
}
@end
