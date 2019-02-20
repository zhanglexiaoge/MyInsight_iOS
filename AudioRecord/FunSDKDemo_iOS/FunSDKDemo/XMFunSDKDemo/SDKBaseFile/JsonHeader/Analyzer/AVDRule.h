#pragma once
#import "FunSDK/JObject.h"

#define JK_AVDRule "AVDRule" 
class AVDRule : public JObject
{
public:
	JIntObj		ChangeEnable;//场景变换检测使能，0关闭，1开启
	JIntObj		ClarityEnable;//清晰度检测使能
	JIntObj		ColorEnable;//偏色检测使能
	JIntObj		FreezeEnable;//画面冻结检测使能
	JIntObj		InterfereEnable;//人为干扰检测使能
	JIntObj		Level; //灵敏度级别
	JIntObj		NoiseEnable;//噪声检测使能
	JIntObj		NosignalEnable;//信号缺失检测使能
	JIntObj		PtzLoseCtlEnable;//PTZ失控检测使能
	JIntObj		tBrightAbnmlEnable;//亮度异常使能

public:
    AVDRule(JObject *pParent = NULL, const char *szName = JK_AVDRule):
    JObject(pParent,szName),
	ChangeEnable(this, "ChangeEnable"),
	ClarityEnable(this, "ClarityEnable"),
	ColorEnable(this, "ColorEnable"),
	FreezeEnable(this, "FreezeEnable"),
	InterfereEnable(this, "InterfereEnable"),
	Level(this, "Level"),
	NoiseEnable(this, "NoiseEnable"),
	NosignalEnable(this, "NosignalEnable"),
	PtzLoseCtlEnable(this, "PtzLoseCtlEnable"),
	tBrightAbnmlEnable(this, "tBrightAbnmlEnable"){
	};

    ~AVDRule(void){};
};
