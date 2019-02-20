

#include "VRSoftDef.h"


#ifndef __VRSOFT_H__
#define __VRSOFT_H__


#ifdef __cplusplus
extern "C" {
#endif


// VR类型定义360VR还是180VR
typedef enum _XMVRType {
	XMVR_TYPE_360D = 0,			// 鱼眼360VR
	XMVR_TYPE_180D = 1,			// 鱼眼180VR

	XMVR_TYPE_ORIGINAL = 2,		// 原始图像
	XMVR_TYPE_SPE_CAM01 = 3,	// XMVR_TYPE_LENOVO, 针对联想客户镜头
	XMVR_TYPE_SPE_CAM02 = 4,	// 预留
	XMVR_TYPE_SPE_CAM03 = 5,	// 预留

	XMVR_TYPE_DULE_360D = 10,	// 双目鱼眼2x360

	XMVR_TYPE_MULTI_IMAGE = 20,	// 多画面拼接, MxN画面,M/N以参数的形式输入,默认为4x4

	XMVR_TYPE_INVALID = 0xffff
} XMVRType;

// 360VR特有的模式
typedef enum _XMVRMount {
	Ceiling = 0,		// 天花板模式
	Wall = 1,			// 墙壁模式
	WallInverted = 2,	// 墙壁反转
	Table = 3,			// 墙壁反转

	Mount_End
} XMVRMount;

typedef enum _XMVRShape {
	Shape_Ball = 0,			// 球/半球(360VR默认)
	Shape_Ball_Hat = 1,		// 球/半球,帽子型,半球倒转
	Shape_Ball_Bowl = 2,	// 球/半球,碗状和Ball_Hat相反
	Shape_Cylinder = 3,		// 圆柱
	Shape_CylinderS = 4,	// 圆柱(近距离型,只能看到部分)
	Shape_Rectangle = 5,	// 矩形,拉伸展开,一行的模式
	Shape_Rectangle_2R = 6,	// 矩形,两行的模式
	Shape_Grid_4R = 7,		// 球/半球矫正,4宫格模式,初始在4个不同的角度
	Shape_Grid_1O_5R = 8,	// 左上角圆图显示,右边和下面5个小窗口显示
	Shape_Grid_1L_2R = 9,	// 上面两个圆放大的矫正效果,下面是一行的效果
	Shape_Grid_3R = 10,		// 3画面

	Shape_End
} XMVRShape;

typedef enum _XMVR180DrawMode {
	Original = 0,
	Stretch = 1,
	Cylinder = 2,
	Dewarper = 3
} XMVR180DrawMode;

// YUV数据格式定义
typedef enum _XMVRPixelFormat {
	XM_PIX_FMT_NONE = 0,
	XM_PIX_FMT_RGB24 = 1,
	XM_PIX_FMT_BGR24 = 2,
	XM_PIX_FMT_YUV420P = 3,
	XM_PIX_FMT_YUYV422 = 4,
	XM_PIX_FMT_YUV422P = 5,
	XM_PIX_FMT_YUV444P = 6,
	XM_PIX_FMT_YUV410P = 7,
	XM_PIX_FMT_YUV411P = 8,
	XM_PIX_FMT_YUV420SP_NV12 = 9,
	XM_PIX_FMT_YUV420SP_NV21 = 10,
	XM_PIX_FMT_EGLImageKHR = 11,	// Hi3798M特有
} XMVRPixelFormat;

typedef void * VRHANDLE;

// 获取当前版本号
const char * VRSoft_Version(void);

// iPhone兼容专用(屏幕实际像素与逻辑像素比例,PPI和屏幕尺寸不同,会有所不同)
// iPhone6P/7P为3,其余为2
void VRSoft_SetPPIZoom(int zoomScale);

// 创建句柄
void VRSoft_Create(VRHANDLE * pHandle);

// 创建句柄,触摸屏事件不在库里面处理
void VRSoft_CreateNoTouchEvent(VRHANDLE * pHandle);

// 销毁句柄
void VRSoft_Release(VRHANDLE hVR);

// 矫正准备,参数初始化
void VRSoft_Prepare(VRHANDLE hVR);

// 初始化可是窗口大小(Viewport)
void VRSoft_Init(VRHANDLE hVR, int width, int height);

// attribute
void VRSoft_SetAttribute(VRHANDLE hVR, const char * name, const char * value);

// 启动自动巡航,speed: 旋转速度,绝对值越大旋转速度越快
void VRSoft_StartAutoCruise(VRHANDLE hVR, double speed);

// 停止所有窗口巡航
void VRSoft_StopAutoCruise(VRHANDLE hVR);


// 获取当前窗口大小
void VRSoft_getViewSize(VRHANDLE hVR, int * pOutWidth, int * pOutHeight);

// 设置VR模式(180VR/360VR)
void VRSoft_SetType(VRHANDLE hVR, XMVRType type);

// 获取当前VR模式
XMVRType VRSoft_GetType(VRHANDLE hVR);

// 如果是180VR,设置图像显示,参考XMVR180DrawMode的定义
void VRSoft_SetDrawMode(VRHANDLE hVR, XMVR180DrawMode drawMode);

// 如果是180VR,设置图像渐变过程
void VRSoft_SetDrawModeCartoon(VRHANDLE hVR,
		XMVR180DrawMode fromMode, XMVR180DrawMode toMode, int step, int total);

// 如果是360VR,设置当前镜头角度(模式),参考XMVRMount的定义
void VRSoft_SetCameraMount(VRHANDLE hVR, XMVRMount mount);

// 如果是360VR,获取当前镜头角度(模式),参考XMVRMount的定义
XMVRMount VRSoft_GetCameraMount(VRHANDLE hVR);

// 如果是360VR,设置当前图像形状
void VRSoft_SetShape(VRHANDLE hVR, XMVRShape shape);

// 如果是360VR,获取当前图像形状
int VRSoft_GetShape(VRHANDLE hVR);

// 设置镜头偏移参数(如果圆心非正中时可设置调节)
void VRSoft_SetFecParams(VRHANDLE hVR, int xCenter, int yCenter,
		int radius, int imgWidth, int imgHeight);

// 刷新图像输出
void VRSoft_Drawself(VRHANDLE hVR);

// 设置RGB格式的图像数据
void VRSoft_SetRGBTexture(VRHANDLE hVR, unsigned char * pData, int len, int width, int height);

// 设置YUV420格式的图像数据
void VRSoft_SetYUV420PTexture(VRHANDLE hVR, unsigned char * pData, int len, int width, int height);

// 通用型数据设置接口
void VRSoft_SetTexture(VRHANDLE hVR, XMVRPixelFormat format,
		unsigned char * pData, int len, int width, int height);

// 设置多画面行数和列数, rowNum * columnNum <= 36, 默认3x3
void VRSoft_Multi_SetScreenNumber(VRHANDLE hVR, int rowNum, int columnNum);

// 设置RGB格式的图像数据(仅多画面拼接可用)
void VRSoft_Multi_SetRGBTexture(VRHANDLE hVR, int gridId,
		unsigned char * pData, int len, int width, int height);

// 设置YUV420格式的图像数据(仅多画面拼接可用)
void VRSoft_Multi_SetYUV420PTexture(VRHANDLE hVR, int gridId,
		unsigned char * pData, int len, int width, int height);

// 通用型数据设置接口(仅多画面拼接可用)
void VRSoft_Multi_SetTexture(VRHANDLE hVR, int gridId,
		XMVRPixelFormat format,
		unsigned char * pData, int len, int width, int height);

#ifdef HI3798M_OPTIMIZED
// only for 3798M
void VRSoft_SetEGLImageKHR(VRHANDLE hVR, EGLImageKHR * pImgHKR, int width, int height);
#ifdef OUTPUT_YUV_IMAGE
//void VRSoft_SetEGLImageKHR_YUVMode(VRHANDLE hVR,
//		EGLImageKHR * pImgHKRIn, EGLImageKHR * pImgHKROut, int width, int height);

// 输入新的YUV数据，指定窗口索引
void VRSoft_SetEGLImageKHR_YUVIn(VRHANDLE hVR, int gridId,
		EGLImageKHR * pImgHKRIn, int width, int height);
// 设置YUV输出内存,一般只调用一次即可
void VRSoft_SetEGLImageKHR_YUVOut(VRHANDLE hVR,
		EGLImageKHR * pImgHKROut);

#endif

#endif


VR_BOOL VRSoft_NeedContinue(VRHANDLE hVR);

// 查看OpenGL错误
VR_BOOL checkOpenGLError(const char * file, int line);

// 重置初始坐标
void VRSoft_ResetPosition(VRHANDLE hVR);

// for 360VR
void VRSoft_SetPTZ(VRHANDLE hVR,
		double pan,
		double tilt,
		double zoom,
		double roll,
		double wallAngle);
void VRSoft_GetPTZ(VRHANDLE hVR,
		double * pOutPan,
		double * pOutTilt,
		double * pOutZoom,
		double * pOutRoll);
// 分屏/多屏处理时使用以下接口
void VRSoft_SetPTZ_SubScreen(VRHANDLE hVR,
		int screenIndex,
		double pan,
		double tilt,
		double zoom,
		double roll,
		double wallAngle);
void VRSoft_GetPTZ_SubScreen(VRHANDLE hVR,
		int screenIndex,
		double * pOutPan,
		double * pOutTilt,
		double * pOutZoom,
		double * pOutRoll);

// for 180VR
// zoom : 0.25 - 1.0 - 20.0
void VRSoft_SetRotateZoom(VRHANDLE hVR,
		double rotateX,
		double rotateY,
		double rotateZ,
		double zoom);
void VRSoft_GetRotateZoom(VRHANDLE hVR,
		double * pOutRotateX,
		double * pOutRotateY,
		double * pOutRotateZ,
		double * pOutZoom);

void VRSoft_SetRotateZoom_SubScreen(VRHANDLE hVR,
		int screenIndex,
		double rotateX,
		double rotateY,
		double rotateZ,
		double zoom);
void VRSoft_GetRotateZoom_SubScreen(VRHANDLE hVR,
		int screenIndex,
		double * pOutRotateX,
		double * pOutRotateY,
		double * pOutRotateZ,
		double * pOutZoom);


// 触摸屏事件处理
void VRSoft_OnTouchDown(VRHANDLE hVR, float x, float y);
void VRSoft_OnTouchUp(VRHANDLE hVR, float x, float y);
void VRSoft_OnTouchMove(VRHANDLE hVR, float x, float y);
void VRSoft_OnTouchPinch(VRHANDLE hVR, float x0, float y0, float x1, float y1);
// 手势捏合,相对缩放比例
void VRSoft_OnTouchPinchScale(VRHANDLE hVR, float dScale);
void VRSoft_OnTouchFling(VRHANDLE hVR, float velocityX, float velocityY);
void VRSoft_AutoAdjust(VRHANDLE hVR);

// 重力加速度感应器
void VRSoft_OnAccelerometer(VRHANDLE hVR, float ax, float ay, float az);

// 指南针/方向传感器事件
void VRSoft_OnOrientation(VRHANDLE hVR, float xDegree, float yDegree, float zDegree);

// 清除最后一帧(视频缓冲)信息
void VRSoft_CleanUp(VRHANDLE hVR);


// 将指定区域显示在屏幕可见区域(屏幕中心正上方)
// 为了同时兼容不同分辨率,传入顶点坐标的同时传入相对应的窗口(视频)分辨率
// (x0, y0) (x1, y1)是相对于xSize/ySize的坐标
void VRSoft_DisplayRect(VRHANDLE hVR,
		int x0, int y0,
		int x1, int y1,
		int width, int height);

// 将指定目标点显示在屏幕可见区域(屏幕中心正上方)
// 为了同时兼容不同分辨率,传入顶点坐标的同时传入相对应的窗口(视频)分辨率
// (x0, y0) (x1, y1)是相对于xSize/ySize的坐标
void VRSoft_DisplayTarget(VRHANDLE hVR,
		int targetX, int targetY,
		int width, int height);




#ifdef __cplusplus
}
#endif

#endif

