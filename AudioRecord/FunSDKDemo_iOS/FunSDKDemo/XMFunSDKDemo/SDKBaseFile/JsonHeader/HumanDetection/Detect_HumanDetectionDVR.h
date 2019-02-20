#pragma once
#import "FunSDK/JObject.h"
#include "EventHandler.h"

#define JK_Detect_HumanDetectionDVR "Detect.HumanDetectionDVR" 
class Detect_HumanDetectionDVR : public JObject
{
public:
	JBoolObj		Enable;
	EventHandler		mEventHandler;
	JIntObj		LoiterLatch;

public:
    Detect_HumanDetectionDVR(JObject *pParent = NULL, const char *szName = JK_Detect_HumanDetectionDVR):
    JObject(pParent,szName),
	Enable(this, "Enable"),
	mEventHandler(this, "EventHandler"),
	LoiterLatch(this, "LoiterLatch"){
	};

    ~Detect_HumanDetectionDVR(void){};
};
