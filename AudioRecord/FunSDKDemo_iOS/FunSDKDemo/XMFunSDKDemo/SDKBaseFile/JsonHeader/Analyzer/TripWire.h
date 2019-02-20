#pragma once
#import "FunSDK/JObject.h"
#include "Line.h"

#define JK_TripWire "TripWire" 
class TripWire : public JObject
{
public:
	JIntObj		ForbiddenDir;
	JIntObj		IsDoubleDir;
	Line		mLine; //单拌线位置
	JIntObj		Valid;

public:
    TripWire(JObject *pParent = NULL, const char *szName = JK_TripWire):
    JObject(pParent,szName),
	ForbiddenDir(this, "ForbiddenDir"),
	IsDoubleDir(this, "IsDoubleDir"),
	mLine(this, "Line"),
	Valid(this, "Valid"){
	};

    ~TripWire(void){};
};
