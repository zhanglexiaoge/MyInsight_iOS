#pragma once
#include "FunSDK/JObject.h"

#define JK_General_General "General.General" 
class General_General : public JObject
{
public:
	JIntObj		AutoLogout;
	JIntObj		FontSize;
	JIntObj		IranCalendarEnable;
	JIntObj		LocalNo;
	JStrObj		MachineName;
	JStrObj		OverWrite;
	JIntObj		ScreenAutoShutdown;
	JIntObj		ScreenSaveTime;
	JIntObj		SnapInterval;
	JStrObj		VideoOutPut;

public:
    General_General(JObject *pParent = NULL, const char *szName = JK_General_General):
    JObject(pParent,szName),
	AutoLogout(this, "AutoLogout"),
	FontSize(this, "FontSize"),
	IranCalendarEnable(this, "IranCalendarEnable"),
	LocalNo(this, "LocalNo"),
	MachineName(this, "MachineName"),
	OverWrite(this, "OverWrite"),
	ScreenAutoShutdown(this, "ScreenAutoShutdown"),
	ScreenSaveTime(this, "ScreenSaveTime"),
	//SnapInterval(this, "SnapInterval"),
	VideoOutPut(this, "VideoOutPut"){
	};

    ~General_General(void){};
};
