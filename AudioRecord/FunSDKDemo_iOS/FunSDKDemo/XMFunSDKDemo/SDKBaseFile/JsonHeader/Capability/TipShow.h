#pragma once
#import "FunSDK/JObject.h"

#define JK_TipShow "TipShow" 
class TipShow : public JObject
{
public:
	JBoolObj		NoBeepTipShow;
	JBoolObj		NoEmailTipShow;
	JBoolObj		NoFTPTipShow;

public:
    TipShow(JObject *pParent = NULL, const char *szName = JK_TipShow):
    JObject(pParent,szName),
	NoBeepTipShow(this, "NoBeepTipShow"),
	NoEmailTipShow(this, "NoEmailTipShow"),
	NoFTPTipShow(this, "NoFTPTipShow"){
	};

    ~TipShow(void){};
};
