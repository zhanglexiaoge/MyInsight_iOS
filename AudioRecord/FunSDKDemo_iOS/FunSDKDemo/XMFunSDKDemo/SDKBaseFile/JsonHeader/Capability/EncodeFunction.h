#pragma once
#import "FunSDK/JObject.h"

#define JK_EncodeFunction "EncodeFunction" 
class EncodeFunction : public JObject
{
public:
	JBoolObj		CombineStream;
	JBoolObj		DoubleStream;
	JBoolObj		IFrameRange;
	JBoolObj		LowBitRate;
	JBoolObj		SmartH264;
	JBoolObj		SnapStream;
	JBoolObj		WaterMark;

public:
    EncodeFunction(JObject *pParent = NULL, const char *szName = JK_EncodeFunction):
    JObject(pParent,szName),
	CombineStream(this, "CombineStream"),
	DoubleStream(this, "DoubleStream"),
	IFrameRange(this, "IFrameRange"),
	LowBitRate(this, "LowBitRate"),
	SmartH264(this, "SmartH264"),
	SnapStream(this, "SnapStream"),
	WaterMark(this, "WaterMark"){
	};

    ~EncodeFunction(void){};
};
