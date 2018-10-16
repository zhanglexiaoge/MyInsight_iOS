//
//   Vector2D.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//

/*
class Vector2D {
public:
	float x,y;
	
	Vector2D();	//コンストラクタ1
	Vector2D(float x, float y);	//コンストラクタ2
	
	Vector2D operator+(const Vector2D &a);	//加算
	Vector2D operator-(const Vector2D &a);	//減算
	Vector2D operator*(const float a);		//乗算
	Vector2D operator/(const float a);		//除算
	
	float getSquareLength();				//長さの二乗を計算します
	Vector2D unitVector();	//単位ベクトルを返します
	float dotProduct(const Vector2D &a);	//内積
};
*/

#import <Foundation/Foundation.h>


@interface Vector2D : NSObject {
	float x;
	float y;
}
- (id) initWithX:(float)X Y:(float)Y;
- (float)getSquareLength;
- (Vector2D*)unitVector;
- (float)dotProduct:(Vector2D*)a;
@property (nonatomic) float x;
@property (nonatomic) float y;
@end