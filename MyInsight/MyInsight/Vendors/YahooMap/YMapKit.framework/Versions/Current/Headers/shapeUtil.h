//
//  shapeUtil.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
//#import "Vector2D.h"

//void line2Rectangle(float width,const Vector2D& a,const Vector2D& b,Vector2D& s,Vector2D& t,Vector2D& u,Vector2D& v);
void line2Rectangle(float width,const float ax,const float ay,const float bx,const float by,float* sx,float* sy,float* tx,float*ty,float* ux,float*uy,float* vx,float* vy);
double calcDistance(double lat1, double lon1, double lat2, double lon2);
double calcAngle(double lat2, double lon2, double lat1, double lon1, double dst);
//double calcAngle(double lat1, double lon1, double lat2, double lon2);
