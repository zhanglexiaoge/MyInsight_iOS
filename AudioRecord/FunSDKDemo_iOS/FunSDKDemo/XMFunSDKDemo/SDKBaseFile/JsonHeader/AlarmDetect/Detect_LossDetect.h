#pragma once
#include "FunSDK/JObject.h"
#include "EventHandler.h"

#define JK_Detect_LossDetect "Detect.LossDetect" 
class Detect_LossDetect : public JObject   //视频丢失
{
public:
	JBoolObj		Enable;
	EventHandler		mEventHandler;

public:
	Detect_LossDetect(JObject *pParent = NULL, const char *szName = JK_Detect_LossDetect):
	JObject(pParent,szName),
	Enable(this, "Enable"),
	mEventHandler(this, "EventHandler"){
	};

	~Detect_LossDetect(void){};
};
