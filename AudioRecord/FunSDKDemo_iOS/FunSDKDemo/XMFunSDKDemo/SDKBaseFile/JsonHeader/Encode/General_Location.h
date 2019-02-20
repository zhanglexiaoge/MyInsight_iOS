#pragma once
#include "FunSDK/JObject.h"
#include "DSTEnd.h"
#include "DSTStart.h"
//通用配置
#define JK_General_Location "General.Location" 
class General_Location : public JObject
{
public:
	DSTEnd		mDSTEnd; //夏令时结束时间
	JStrObj		DSTRule; //夏令时开关
	DSTStart		mDSTStart; //夏令时开启时间
	JStrObj		DateFormat; //日期格式
	JStrObj		DateSeparator;
	JStrObj		Language; //语言选择
	JStrObj		TimeFormat; //时间格式
	JStrObj		VideoFormat; //视频制式
	JIntObj		WorkDay; //工作日

public:
	General_Location(JObject *pParent = NULL, const char *szName = JK_General_Location):
	JObject(pParent,szName),
	mDSTEnd(this, "DSTEnd"),
	DSTRule(this, "DSTRule"),
	mDSTStart(this, "DSTStart"),
	DateFormat(this, "DateFormat"),
	DateSeparator(this, "DateSeparator"),
	Language(this, "Language"),
	TimeFormat(this, "TimeFormat"),
	VideoFormat(this, "VideoFormat"),
	WorkDay(this, "WorkDay"){
	};

	~General_Location(void){};
};
