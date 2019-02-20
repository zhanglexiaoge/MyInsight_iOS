#pragma once
#import "FunSDK/JObject.h"
#import "Points.h"
#define JK_SubRgC "SubRgC" 
class SubRgC : public JObject
{
public:
	JIntObj		PointNu;
	JObjArray<Points>		Points;
	JIntObj		Valid;

public:
    SubRgC(JObject *pParent = NULL, const char *szName = JK_SubRgC):
    JObject(pParent,szName),
	PointNu(this, "PointNu"),
	Points(this, "Points"),
	Valid(this, "Valid"){
	};

    ~SubRgC(void){};
};
