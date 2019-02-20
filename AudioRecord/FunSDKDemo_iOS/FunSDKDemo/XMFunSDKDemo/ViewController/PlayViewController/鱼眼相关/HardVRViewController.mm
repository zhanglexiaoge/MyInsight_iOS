//
//  HardVRViewController.m
//  XWorld
//
//  Created by Apple on 16/8/29.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import "HardVRViewController.h"
#import "VRGLViewController.h"
#include "fisheye.h"
#include "fisheye_opengl.h"
#include "fisheye_errordef.h"
#define RAD_TO_DEG( rad ) ( (rad) * 57.29577951f )
using namespace std;

@interface HardVRViewController ()
{
    HANDLE      _hFECtx;
    FEOPTION    _tFEOption;
    CGPoint     _touchBegPoint;
    CGPoint     _touchEndPoint;
    BOOL        _touched;
    QUEUE_YUV_DATA _yuvDatas;
    unsigned char * _pbyYUV;
    pthread_mutex_t lock_yuv;
    int _nYUVBufLen;
    float       fDeltaPan;
    float       fDeltaTilt;
    float pPan;
    float pTilt;
    NSInteger numbers;
    BOOL isOverleft;//
    BOOL isGravity;//是否开启重力感应
    BOOL   _IsYuv;
    BOOL isZoomJ;//zoom 减小
    BOOL isZoomK;//zoom 扩大
    int  zoomK;
    BOOL isMove;//判断手指停留 惯性停止
    BOOL isTouchMove;
    BOOL isDraw;//是否开始画图像

}
@property(strong,nonatomic)EAGLContext* context;
@property (strong, nonatomic) NSDate *begDate;
@property (strong,nonatomic) NSDate *endDate;
@end

@implementation HardVRViewController
-(id)init{
    self = [super init];
    if ( self ) {
       
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }

    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.context];
    // Initial fisheye library
    SCODE scRet = Fisheye_Initial(&_hFECtx, LIBFISHEYE_VERSION);
    if (scRet != FISHEYE_S_OK)
    {
        NSLog(@"Fisheye_Initial Failed. (%lx)", scRet);
    }
    [self setDewarpType:FE_DEWARP_AROUNDVIEW];
    [self setMountType:FE_MOUNT_CEILING];
    
    Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_ABSOLUTE, 0, 0, 1);
    
    [self loadYUVImageFromFile];
//    UITapGestureRecognizer* singleRecognizer= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(single:)];
//    //点击的次数
//    singleRecognizer.numberOfTapsRequired = 1; // 单击
//    
//    //给self.view添加一个手势监测；
//    
//    [self.view addGestureRecognizer:singleRecognizer];
    
    _ZoomNumber = 2;
    

}
//-(void)single:(UITapGestureRecognizer *)sender
//{
//    
//}
- (void) setMountType:(FEMOUNTTYPE) mount
{
    _tFEOption.MountType = mount;
    _tFEOption.Flags = FE_OPTION_MOUNTTYPE;
    Fisheye_SetOption(_hFECtx, &_tFEOption);
}

- (void) setDewarpType:(FEDEWARPTYPE) dewarpType
{
    _tFEOption.DewarpType = dewarpType;
    _tFEOption.Flags = FE_OPTION_DEWARPTYPE;
    Fisheye_SetOption(_hFECtx, &_tFEOption);
}
- (void)handleFisheyeInput:(unsigned int)width height:(unsigned int)height buffer:(const void *)buffer
{
    // Update InVPicture header
    if (_tFEOption.InVPicture.Width != width || _tFEOption.InVPicture.Height != height || _tFEOption.InVPicture.Format != FE_PIXELFORMAT_YUV420P)
    {
        // Set input image information
        _tFEOption.InVPicture.Width = width;
        _tFEOption.InVPicture.Height = height;
        _tFEOption.InVPicture.Stride = width;
        _tFEOption.InVPicture.Format = FE_PIXELFORMAT_YUV420P;
        
        // Set center and radius
        _tFEOption.FOVCenter.X = (_tFEOption.InVPicture.Width >> 1);
        _tFEOption.FOVCenter.Y = 20;//(_tFEOption.InVPicture.Height >> 1);
        _tFEOption.FOVRadius = _tFEOption.InVPicture.Width >> 1;
        
        // Update parameters in fisheye library
        _tFEOption.Flags = (FE_OPTION_INIMAGEHEADER | FE_OPTION_FOVCENTER | FE_OPTION_FOVRADIUS);
        Fisheye_SetOption(_hFECtx, &_tFEOption);
    }
    
    if (_tFEOption.InVPicture.Buffer != (BYTE*)buffer)
    {
        _tFEOption.InVPicture.Buffer = (BYTE*)buffer;
        _tFEOption.Flags = (FE_OPTION_INIMAGEBUFFER);
        Fisheye_SetOption(_hFECtx, &_tFEOption);
    }
}

- (void)loadYUVImageFromFile
{
    SYUVData *pData = [self PopData];
    if (pData) {
        int nDataLen = pData->width * pData->height * 3 / 2;
        
        
        if (_nYUVBufLen< nDataLen || _pbyYUV == NULL) {
            if (_pbyYUV) {
                free(_pbyYUV);
                _pbyYUV = NULL;
            }
            _pbyYUV = (unsigned char *)malloc(nDataLen);//new unsigned char[nDataLen];
            _nYUVBufLen = nDataLen;
        }
        memcpy(_pbyYUV, pData->pData, nDataLen);
        
        [self handleFisheyeInput:pData->width  height:pData->height buffer:_pbyYUV];
        delete pData;
        //[self ClearYUVData];
    }
    
    
}
- (void) handleDrawLocation:(GLKView *)view
{
    unsigned int drawableWidth = (unsigned int)view.drawableWidth;
    unsigned int drawableHeight = (unsigned int)view.drawableHeight;
    
    if (_tFEOption.OutVPicture.Width != drawableWidth || _tFEOption.OutVPicture.Height != drawableHeight)
    {
        _tFEOption.OutVPicture.Width = drawableWidth;
        _tFEOption.OutVPicture.Height = drawableHeight;
        _tFEOption.OutVPicture.Format = FE_PIXELFORMAT_RGB32;
        
        
        _tFEOption.OutRoi.Top       = 0;
        
        _tFEOption.OutRoi.Top       = 0;
        
        _tFEOption.OutRoi.Right     = _tFEOption.OutVPicture.Width;
        _tFEOption.OutRoi.Bottom    = _tFEOption.OutVPicture.Height;//_tFEOption.OutVPicture.Height;
        
        _tFEOption.Flags = (FE_OPTION_OUTIMAGEHEADER | FE_OPTION_OUTROI);
        Fisheye_SetOption(_hFECtx, &_tFEOption);
    }
    
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
//    if (!isDraw) {
//        return;
//    }
    // Clear framebuffer

    glClearColor(0, 0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // load image
    [self loadYUVImageFromFile];
    
    // Update draw location
    [self handleDrawLocation:view];
    if(isZoomK)
    {
        [self FishEyeZoomK];
    }
    if (isZoomJ) {
        [self FishEyeZoomJ];
    }
    
    if(_touched == NO)
    {
        
        //        if(!isOverturn)
        //        {
        
        if (numbers>1)
        {
            
        }
        else
        {
            
            float NowZoom=0;
            Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt),&NowZoom );//获取扩大活着缩小的倍数
            if (NowZoom < _ZoomNumber)
            {
                if (isTouchMove)
                {
                    [self fishEyeZoomK:NowZoom];
                    
                }
                
            }
            else
            {
                
                float pMaxTilt;//当前放大倍数的边界角度
                float pMinTilt;
                Fisheye_GetCurrentTiltBoundary(_hFECtx, &(pMinTilt), &(pMaxTilt));
                if(pTilt > pMaxTilt)
                {
                    [self fishEyeSpringback:pPan];
                }
                else
                {
//                    if (self.bFull ==YES && isGravity ==YES)
//                    {
//                        
//                    }
//                    else
//                    {
                        [self fishEyeinertialsystem];
                   // }
                }
                
            }
        }
        // }
    }

    SCODE scRet = Fisheye_OneFrame(_hFECtx);
//    if (scRet != FISHEYE_S_OK)
//    {
//        NSLog(@"Fisheye_OneFrame Failed. (%lx)\n", scRet);
//    }

}
-(void)PushData:(int)width height:(int)height YUVData:(unsigned char *)pData
{
    @synchronized(self)
    {
        SYUVData *pNew = new SYUVData(width, height, pData);
        _yuvDatas.push(pNew);
        int nSize = (int)_yuvDatas.size();
        for (int i = 4; i < nSize; i++) {
            SYUVData *item = _yuvDatas.front();
            _yuvDatas.pop();
            delete item;
        }
    }
    isDraw = YES;
}
-(SYUVData *)PopData
{
    SYUVData *pItem = NULL;
    @synchronized(self)
    {
        if (!_yuvDatas.empty()) {
            pItem = _yuvDatas.front();
            _yuvDatas.pop();
        }
    }
    return pItem;
    
    
}


#pragma mark 滑动开始
-(void)HardTouchbegan:(CGPoint)BegPoint
{
     self.begDate=[NSDate date];
    _touchBegPoint = BegPoint;
    _touched = true;

}
#pragma mark 滑动
-(void)HardTouchMove:(CGPoint)MovePoint
{
    if (_touched != true)
    {
        return;
    }
    _touchEndPoint = MovePoint;
    isTouchMove = YES;
    // Calculate the difference between begin position and current position
    float fDistanceX = _touchEndPoint.x - _touchBegPoint.x;
    float fDistanceY = _touchEndPoint.y - _touchBegPoint.y;
    
    // Fluent control
    fDeltaPan = 0;
    fDeltaTilt = 0;
    float fWidthInView = (_tFEOption.OutRoi.Right - _tFEOption.OutRoi.Left) * self.view.frame.size.width / _tFEOption.OutVPicture.Width;
    float fHeightInView = (_tFEOption.OutRoi.Bottom - _tFEOption.OutRoi.Top) * self.view.frame.size.height / _tFEOption.OutVPicture.Height;
    
    if (FE_DEWARP_RECTILINEAR == _tFEOption.DewarpType)
    {
        float fPan = 0, fTilt = 0, fZoom = 0;
        Fisheye_GetPanTiltZoom(_hFECtx, &fPan, &fTilt, &fZoom);
        
        // Move right/left
        if (FE_MOUNT_WALL == _tFEOption.MountType)
        {
            float fAspectRatio = fWidthInView / fHeightInView;
            float fD1 = ((float)_touchBegPoint.x / fWidthInView * 2.0f - 1.0f) / fZoom * fAspectRatio;
            float fD2 = ((float)_touchEndPoint.x / fWidthInView * 2.0f - 1.0f) / fZoom * fAspectRatio;
            float fTheta1 = RAD_TO_DEG(atanf(fD1));
            float fTheta2 = RAD_TO_DEG(atanf(fD2));
            fDeltaPan = (fTheta2 - fTheta1);
        }
        else
        {
            fDeltaPan = RAD_TO_DEG(atanf(fDistanceX / (fWidthInView * 0.5 * fZoom)));
        }
        
        // Move up/down
        fDeltaTilt = RAD_TO_DEG(atanf(fDistanceY / (fHeightInView * 0.5 * fZoom)));
    }
    else if (FE_DEWARP_FULLVIEWPANORAMA == _tFEOption.DewarpType)
    {
        fDeltaPan = fDistanceX / fWidthInView * 360.0f;
    }
    else if (FE_DEWARP_DUALVIEWPANORAMA == _tFEOption.DewarpType)
    {
        fDeltaPan = fDistanceX / fWidthInView * 180.0f;
    }
    else if (FE_DEWARP_AROUNDVIEW == _tFEOption.DewarpType)
    {
        fDeltaPan = fDistanceX;
        fDeltaTilt = fDistanceY;
    }
    
    Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, -fDeltaPan/2, fDeltaTilt/2, 0);
    
    // Update points
    _touchBegPoint = _touchEndPoint;

    
}
#pragma mark 滑动结束
-(void)HardTouchEnd:(CGPoint)EndPoint
{
    self.endDate=[NSDate date];
    numbers=[self comparebegtime];
    _touched = false;

}
#pragma mark 捏合手势
-(void)HardtouchesPinch:(CGFloat)Velocity
{
    float NowZoom=0;
    Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt),&NowZoom );//获取扩大活着缩小的倍数

        if(NowZoom > _ZoomNumber)//倍数大于2倍
        {
            float zo= NowZoom + (Velocity/20);
            if (zo >= 3.5 )
            {
                return;
            }
            Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, 0, 0,Velocity/20);
        }
        else//小于2倍
        {
            
            float zo= NowZoom + (Velocity/20);
            if (zo >= 1.1 )
            {
                return;
            }
            Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, 0, 0,Velocity/20);
            
        }

       float Zooms=0;
    Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt),&Zooms );//获取扩大活着缩小的倍数
    if (Zooms > NowZoom)
    {
        isZoomK = YES;
    }
    if (Zooms < NowZoom)
    {
        isZoomJ = YES;
    }
   

}                                
-(NSInteger)comparebegtime{
    
    NSUInteger unitFlags =
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cps = [calendar components:unitFlags fromDate:self.begDate  toDate:self.endDate  options:0];
    return  [cps second];
    
}
#pragma mark- 自动扩大
-(void)fishEyeZoomK:(float)NowZoom
{
    
    Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt),&NowZoom );//获取扩大活着缩小的倍数
    if (NowZoom >= _ZoomNumber)
    {
        _touched = YES;
        isTouchMove = NO;
        //[self fishEyeSpringback];
        // [self fishEyeSpringback:pPan];
    }
    else
    {
        
        Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, 0, 0.5, 0) ;
        Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, 0, 0.5, 0.02) ;
        NSLog(@"Fisheye_GetPanTiltZoom---------------->%f",pTilt);
    }
}
-(void)fishEyeSpringback:(float)Pan
{
    if (fDeltaPan > 0)
    {
        Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, -(fDeltaPan), -3, 0) ;
        fDeltaPan = fDeltaPan*2/3;
    }
    else
    {
        Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, -(fDeltaPan), -3, 0) ;
        fDeltaPan = fDeltaPan*2/3;
    }
}
#pragma mark-惯性移动
-(void)fishEyeinertialsystem
{
    if (fDeltaPan > 0 && fDeltaPan < 0.1)
    {
        fDeltaPan = 0.15;
    }
    if (fDeltaPan > -0.1 && fDeltaPan < 0)
    {
        fDeltaPan = -0.15;
    }
    if (fDeltaTilt > 0 && fDeltaTilt < 0.1)
    {
        fDeltaTilt = 0.15;
    }
    if (fDeltaTilt > -0.1 && fDeltaTilt < 0)
    {
        fDeltaTilt = -0.15;
    }
    Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, -fDeltaPan, 0, 0) ;
    float  fDeltaT = fDeltaTilt/2;
    float  fDeltaP = fDeltaPan/2;
    fDeltaTilt = fDeltaT;
    fDeltaPan = fDeltaP;
}
#pragma mark 惯性滑动停止
-(void)MoveStop
{
    fDeltaPan=0;
    fDeltaTilt=0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)HardoutputRotationData:(double)rotationX rotationY:(double)rotationY
{
    float Zoom = 0;
    Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt), &Zoom);//获取当前试图的放大倍数
    double fDistanceX = rotationX;
    double fDistanceY = rotationY;
    if (fDistanceX < 10 && fDistanceX > -10) {//限制陀螺仪的转动（x坐标）
        
        if(fDistanceY < 10 && fDistanceY > -10){//限制陀螺仪的转动（y坐标）
            
            return;
        }else{
            
            fDistanceX = 0;
        }
        
    }
    if (isOverleft) {
        fDistanceY = 0-fDistanceY;
    }else{
        fDistanceX = 0-fDistanceX;
    }
    if (Zoom >= 2) {//试图放大倍数大于2 限制转动距离
       
    }
    else
    {
        fDistanceY = fDistanceY/3;
        fDistanceX = fDistanceX/3;
    }
    
    // Fluent control
    float fDeltaPans = 0;
    float fDeltaTilts = 0;
    float fWidthInView = (_tFEOption.OutRoi.Right - _tFEOption.OutRoi.Left) * self.view.frame.size.width / _tFEOption.OutVPicture.Width;
    float fHeightInView = (_tFEOption.OutRoi.Bottom - _tFEOption.OutRoi.Top) * self.view.frame.size.height / _tFEOption.OutVPicture.Height;
    
    if (FE_DEWARP_AROUNDVIEW == _tFEOption.DewarpType  || FE_DEWARP_RECTILINEAR== _tFEOption.DewarpType)
    {
        float fPan = 0, fTilt = 0, fZoom = 0;
        Fisheye_GetPanTiltZoom(_hFECtx, &fPan, &fTilt, &fZoom);
        
        // Move right/left
        if (FE_MOUNT_WALL == _tFEOption.MountType)
        {
            float fAspectRatio = fWidthInView / fHeightInView;
            float fD1 = ((float)_touchBegPoint.x / fWidthInView * 2.0f - 1.0f) / fZoom * fAspectRatio;
            float fD2 = ((float)_touchEndPoint.x / fWidthInView * 2.0f - 1.0f) / fZoom * fAspectRatio;
            float fTheta1 = RAD_TO_DEG(atanf(fD1));
            float fTheta2 = RAD_TO_DEG(atanf(fD2));
            fDeltaPans = (fTheta2 - fTheta1);
        }
        else
        {
            fDeltaPans = RAD_TO_DEG(atanf(fDistanceX / (fWidthInView * 0.5 * fZoom)));
        }
        
        // Move up/down
        fDeltaTilts = RAD_TO_DEG(atanf(fDistanceY / (fHeightInView * 0.5 * fZoom)));
    }
    else if (FE_DEWARP_FULLVIEWPANORAMA == _tFEOption.DewarpType)
    {
        fDeltaPans = fDistanceX / fWidthInView * 360.0f;
    }
    else if (FE_DEWARP_DUALVIEWPANORAMA == _tFEOption.DewarpType)
    {
        fDeltaPans = fDistanceX / fWidthInView * 180.0f;
    }
    
    Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, -fDeltaPans, fDeltaTilts, 0);

}
#pragma mark 手势扩大
-(void)FishEyeZoomK
{
    float NowZoom=0;
    Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt),&NowZoom );//获取扩大活着缩小的倍数
    if (NowZoom < 2)
    {
        float fP = 0 ;
        float fT = 0.5;
        Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, fP, fT, 0.0015) ;
        Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt),&NowZoom );//获取扩大活着缩小的倍数
        NSLog(@"this is-----------------pTlit%f",pTilt);
        if(pTilt >-60)
        {
            Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, 0, 0.3, 0.02) ;
        }
        
    }
    else
    {
        isTouchMove = NO;
        isZoomK = NO;
        _touched = NO;
    }
    Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt),&NowZoom );//获取扩大活着缩小的倍数
}
#pragma mark 手势缩小
-(void)FishEyeZoomJ
{
    float NowZoom=0;
    Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt),&NowZoom );//获取扩大活着缩小的倍数
    NSLog(@"================================%f",NowZoom);
    if (NowZoom < 2)
    {
        float fP = 0 ;
        float fT = -0.6;
        Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, fP, fT, 0) ;
        Fisheye_SetPanTiltZoom(_hFECtx, FE_POSITION_RELATIVE, 0, -0.6, -0.05) ;
    }
    Fisheye_GetPanTiltZoom(_hFECtx, &(pPan), &(pTilt),&NowZoom );//获取扩大活着缩小的倍数
    if (pTilt == -90 && NowZoom <= 1.01) {
        isZoomJ = NO;
        isTouchMove = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
