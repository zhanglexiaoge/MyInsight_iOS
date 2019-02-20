#pragma once
#import "FunSDK/JObject.h"

#define JK_OscPara "OscPara" 
class OscPara : public JObject
{
public:
	JIntObj		SizeMax;  //最大尺寸
	JIntObj		SizeMin;   //最小尺寸
	JIntObj		TimeMin;   //时间约束

public:
    OscPara(JObject *pParent = NULL, const char *szName = JK_OscPara):
    JObject(pParent,szName),
	SizeMax(this, "SizeMax"),
	SizeMin(this, "SizeMin"),
	TimeMin(this, "TimeMin"){
	};

    ~OscPara(void){};
};
