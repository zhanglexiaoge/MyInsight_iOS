#pragma once
#include "FunSDK/JObject.h"
#include "EventHandler.h"

#define JK_Detect_MotionDetect "Detect.MotionDetect" 
class Detect_MotionDetect: public JObject   //移动侦测
{
public:
	JBoolObj		Enable;
	EventHandler		mEventHandler;
	JIntObj		Level;
	JObjArray<JIntHex>		Region;

public:
	Detect_MotionDetect(JObject *pParent = NULL, const char *szName = JK_Detect_MotionDetect):
	JObject(pParent,szName),
	Enable(this, "Enable"),
	mEventHandler(this, "EventHandler"),
	Level(this, "Level"),
	Region(this, "Region"){
	};

	~Detect_MotionDetect(void){};
};
