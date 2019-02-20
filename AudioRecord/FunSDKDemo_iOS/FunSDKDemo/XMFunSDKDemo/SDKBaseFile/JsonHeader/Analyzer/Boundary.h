#pragma once
#import "FunSDK/JObject.h"
#import "Points.h"

#define JK_Boundary "Boundary"
class Boundary : public JObject
{
public:
	JIntObj		PointNum; //边界点数
	JObjArray<Points>		Points;//数组里面是字典[{"x":100,"y":100},{"x":100,"y":100},{"x":100,"y":100}]

public:
    Boundary(JObject *pParent = NULL, const char *szName = JK_Boundary):
    JObject(pParent,szName),
	PointNum(this, "PointNum"),
	Points(this, "Points"){
	};

    ~Boundary(void){};
};
