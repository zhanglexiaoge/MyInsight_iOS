//
//  VRGLViewController.h
//  VRDemo
//
//  Created by J.J. on 16/8/26.
//  Copyright © 2016年 xm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "VRSoft.h"
#include <queue>
using namespace std;

typedef struct SYUVData
{
    int width;
    int height;
    unsigned char *pData;
    SYUVData(int width, int height, unsigned char *pData)
    {
        this->width = width;
        this->height = height;
        int len = width * height * 3 / 2;
        if(len > 0){
            this->pData = new unsigned char[len];
            memcpy(this->pData, pData, len);
        } else {
            this->pData = NULL;
        }
    }
    ~SYUVData()
    {
        if(pData){
            delete []pData;
            pData = NULL;
        }
    }
} SYUVData;
typedef std::queue<SYUVData *> QUEUE_YUV_DATA;

@interface VRGLViewController : GLKViewController

@property (nonatomic,assign) int VRShowMode;
@property (nonatomic, assign) BOOL changeModel;         //是否切换吸顶模式和壁挂模式

//设置软解
-(void)configSoftEAGLContext;

-(void)setVRType:(XMVRType)type;

-(void)setVRShapeType:(XMVRShape)shapetype;

-(void)setVRVRCameraMount:(XMVRMount)Mount;
//鱼眼参数设置(半径宽高)
-(void)setVRFecParams:(int)xCenter yCenter:(int)yCenter radius:(int)radius Width:(int)imgWidth Height:(int)imgHeight;

-(void)PushData:(int)width height:(int)height YUVData:(unsigned char *)pData;

//智能分析报警之后界面旋转
-(void)setAnalyzeWithXL:(int)x0 YL:(int)y0 XR:(int)x1 YR:(int)y1 Width:(int)imgWidth Height:(int)imgHeight;

//滑动开始
-(void)SoftTouchMoveBegan:(NSSet *)SoftTouch Softevent:(UIEvent *)Softevent;
//滑动
-(void)SoftTouchMove:(NSSet *)SoftTouch Softevent:(UIEvent *)Softevent;
//滑动结束
-(void)SoftTouchMoveEnd:(NSSet *)SoftTouch Softevent:(UIEvent *)Softevent;

//捏合手势
-(void)SoftTouchesPinch:(CGFloat)scale;

-(void)reloadInitView:(CGRect)frame;

-(void)DoubleTap:(UITapGestureRecognizer*)recognizer;//双击手势

@end
