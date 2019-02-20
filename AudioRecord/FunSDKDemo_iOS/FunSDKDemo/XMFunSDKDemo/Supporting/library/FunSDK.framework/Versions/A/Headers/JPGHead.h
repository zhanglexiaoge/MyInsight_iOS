/*
 * *****************************************************
 * XIONGMAI All Right Reserved.
 *
 * jpghead.h
 *
 *  Created on: 2016年8月31日
 *      Author: Jason
 * *****************************************************
 */

#ifndef JPGEXIF_JPGHEAD_H_
#define JPGEXIF_JPGHEAD_H_



#define VR_FRAME_TYPE_HW	0x03
#define VR_FRAME_TYPE_SW	0x04
#define VR_FRAME_TYPE_CM	0x05


typedef struct {
	int version;	// 版本号
	int sensor;		// 硬校正特有参数，参考鱼眼信息帧中：SDK_FishEyeParam.FISHEYE_SECENE_E定义
} FishEyeFrameHW;

typedef struct {
	int version;	// 版本号
	int lensType;	// 软校正参数，镜头类型，同信息帧中枚举E_FISH_LENS_TYPE
	int centerX;	// 圆心偏差横坐标  单位:像素点
	int centerY;	// 圆心偏差纵坐标  单位:像素点
	int radius;		// 半径  单位:像素点
	int imgWidth;	// 圆心校正时的图像宽度  单位:像素点
	int imgHeight;	// 圆心校正时的图像高度  单位:像素点
	int viewAngle;	// 视角	0:俯视   1:平视
	int viewMode;	// 显示模式   0:360VR(此参数暂不判断，通过VR_LENSTYPE判断)
} FishEyeFrameSW;

typedef struct {
	int version;	// 版本号
	int cameraType;	// 镜头类型COM1=0,COM2=1...
} FishEyeFrameCM;	// Common Camera

typedef struct {
	unsigned char type;	// VR_FRAME_TYPE_HW or VR_FRAME_TYPE_SW
	union {
		FishEyeFrameHW frameHW;
		FishEyeFrameSW frameSW;
		FishEyeFrameCM frameCM;
	} param;
} FishEyeFrameParam;

/**
 * 鱼眼硬矫正EXIF头写入
 * srcPath : 原文件路径
 * dstPath : 目标文件路径(如果覆盖原文件,同原文件路径)
 * pFrameHW : 硬矫正参数
 * return : 0成功, 非0失败
 */
int jpghead_write_vrhw_exif(char * srcPath, char * dstPath, FishEyeFrameHW * pFrameHW);

/**
 * 普通镜头畸变矫正EXIF头写入
 * srcPath : 原文件路径
 * dstPath : 目标文件路径(如果覆盖原文件,同原文件路径)
 * pFrameCM : 畸变矫正参数
 * return : 0成功, 非0失败
 */
int jpghead_write_common_exif(char * srcPath, char * dstPath, FishEyeFrameCM * pFrameCM);

/**
 * 鱼眼软矫正EXIF头写入
 * srcPath : 原文件路径
 * dstPath : 目标文件路径(如果覆盖原文件,同原文件路径)
 * pFrameSW : 软矫正参数
 * return : 0成功, 非0失败
 */
int jpghead_write_vrsw_exif(char * srcPath, char * dstPath, FishEyeFrameSW * pFrameSW);


/**
 * 鱼眼矫正信息写入,同jpghead_write_vrhw_exif和jpghead_write_vrsw_exif
 * return : 0成功, 非0失败
 */
int jpghead_write_exif(char * srcPath, char * dstPath, FishEyeFrameParam * pFrame);

/**
 * 从文件中读取鱼眼矫正参数
 * return : 0成功, 非0失败(或者是非鱼眼图片)
 */
int jpghead_read_exif(char * srcPath, FishEyeFrameParam * pFrame);


#endif /* JPGEXIF_JPGHEAD_H_ */

