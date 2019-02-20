#pragma once
#include "FunSDK/JObject.h"
#include "ExposureParam.h"
#include "GainParam.h"

#define JK_Camera_Param "Camera.Param" 
class Camera_Param: public JObject  //获取图像翻转、曝光时间、情景模式、电子慢快门、色彩模式等等
{
public:
	JIntObj		AeSensitivity;
	JIntHex		ApertureMode;
	JIntHex		BLCMode;
	JIntHex		DayNightColor;
	JIntObj		Day_nfLevel;
	JIntObj		DncThr;
	JIntObj		ElecLevel;
	JIntHex		EsShutter;
	ExposureParam		mExposureParam;
	GainParam		mGainParam;
	JIntObj		IRCUTMode;
	JIntObj		IrcutSwap;
	JIntObj		Night_nfLevel;
	JIntHex		PictureFlip;
	JIntHex		PictureMirror;
	JIntHex		RejectFlicker;
	JIntHex		WhiteBalance;

public:
	Camera_Param(JObject *pParent = NULL, const char *szName = JK_Camera_Param):
	JObject(pParent,szName),
	AeSensitivity(this, "AeSensitivity"),
	ApertureMode(this, "ApertureMode"),
	BLCMode(this, "BLCMode"),
	DayNightColor(this, "DayNightColor"),
	Day_nfLevel(this, "Day_nfLevel"),
	DncThr(this, "DncThr"),
	ElecLevel(this, "ElecLevel"),
	EsShutter(this, "EsShutter"),
	mExposureParam(this, "ExposureParam"),
	mGainParam(this, "GainParam"),
	IRCUTMode(this, "IRCUTMode"),
	IrcutSwap(this, "IrcutSwap"),
	Night_nfLevel(this, "Night_nfLevel"),
	PictureFlip(this, "PictureFlip"),
	PictureMirror(this, "PictureMirror"),
	RejectFlicker(this, "RejectFlicker"),
	WhiteBalance(this, "WhiteBalance"){
	};

	~Camera_Param(void){};
};
