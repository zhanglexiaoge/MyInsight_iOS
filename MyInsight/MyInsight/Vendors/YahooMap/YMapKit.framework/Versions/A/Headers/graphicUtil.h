//
//  graphicUtil.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "Vector2D.h"
#import "Vector3D.h"

//ここから関数の定義です
void drawSquare();
void drawSquare(int red, int green, int blue, int alpha);
void drawSquare(float x, float y, int red, int green, int blue, int alpha);

void drawRectangle(float x, float y, float width, float height, int red, int green, int blue, int alpha);

void drawTexture(float x, float y, float width, float height, GLuint texture, int red, int green, int blue, int alpha);
void drawTexture(float x, float y, float width, float height, GLuint texture, float u, float v, float tex_width, float tex_height, int red, int green, int blue, int alpha);

void drawCircle(float x, float y, int divides, float radius, int red, int green, int blue, int alpha);

void drawNumber(float x, float y, float width, float height, GLuint texture, int number, int red, int green, int blue, int alpha);
void drawNumbers(float x, float y, float width, float height, GLuint texture, int number, int figures, int red, int green, int blue, int alpha);

GLuint loadTexture(NSString* fileName);

void drawTriangle(const Vector2D& p1, const Vector2D& p2, const Vector2D& p3, float r, float g, float b, float a);
void drawCube(float x, float y, float z,float width, float height, float depth, int red, int green, int blue, int alpha);
void drawPolygon(const Vector2D& a,const Vector2D& b,const Vector2D& c,const Vector2D& d, int red, int green, int blue, int alpha);
void drawPolygon(const Vector3D& a,const Vector3D& b,const Vector3D& c,const Vector3D& d, int red, int green, int blue, int alpha);

//Vector2Dクラスで座標を指定できるようにした関数です
void drawCircle(Vector2D center, int divides, float radius, int red, int green, int blue, int alpha);
*/

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

void drawRectangle(float x, float y, float width, float height, int red, int green, int blue, int alpha);
void drawTriangle(const float x1, const float y1, const float x2, const float y2, const float x3, const float y3, float r, float g, float b, float a);