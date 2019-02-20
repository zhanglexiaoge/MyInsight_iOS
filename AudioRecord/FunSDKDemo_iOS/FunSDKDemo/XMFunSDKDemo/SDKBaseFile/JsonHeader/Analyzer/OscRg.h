#pragma once
#import "FunSDK/JObject.h"
#import "Points.h"
#define JK_OscRg "OscRg" 
class OscRg : public JObject
{
public:
	JIntObj		PointNu; //点的数量
	JObjArray<Points>		Points;//点数组
	JIntObj		Valid;

public:
    OscRg(JObject *pParent = NULL, const char *szName = JK_OscRg):
    JObject(pParent,szName),
	PointNu(this, "PointNu"),
	Points(this, "Points"),
	Valid(this, "Valid"){
	};

    ~OscRg(void){};
};
