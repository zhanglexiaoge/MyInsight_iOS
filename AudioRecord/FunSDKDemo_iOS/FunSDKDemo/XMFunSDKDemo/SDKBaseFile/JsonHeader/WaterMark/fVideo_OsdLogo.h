#pragma once
#include "FunSDK/JObject.h"

#define JK_fVideo_OsdLogo "fVideo.OsdLogo" 
class fVideo_OsdLogo : public JObject
{
public:
	JIntObj		BgTrans;
	JIntObj		Enable;
	JIntObj		FgTrans;
	JIntObj		Left;
	JIntObj		Top;

public:
    fVideo_OsdLogo(JObject *pParent = NULL, const char *szName = JK_fVideo_OsdLogo):
    JObject(pParent,szName),
	BgTrans(this, "BgTrans"),
	Enable(this, "Enable"),
	FgTrans(this, "FgTrans"),
	Left(this, "Left"),
	Top(this, "Top"){
	};

    ~fVideo_OsdLogo(void){};
};
