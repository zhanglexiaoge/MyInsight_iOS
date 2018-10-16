//
//  YRouteControl.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "YMKRouteLine.h"
#import "YMKRouteOverlay.h"

@interface YMKRouteControl : NSObject {
	NSMutableArray* lineArray;		//ライン配列
	YRoutePoint* m_select_line[2];	//選択された線分
	long defTotalTime;			//デフォルトのトータル時間
	long defTotalDistance;			//デフォルトのトータル時間
	id<YMKRouteOverlayDelegate> delegate; //デリゲート
	
	CLLocationCoordinate2D startPos;
	CLLocationCoordinate2D goalPos;	
}

@property (nonatomic) CLLocationCoordinate2D startPos;
@property (nonatomic) CLLocationCoordinate2D goalPos;
@property (nonatomic) long defTotalTime;
@property (nonatomic) long defTotalDistance;
@property (nonatomic, assign) id <YMKRouteOverlayDelegate> delegate;

- (int) count;
- (void) addRouteLine:(YRouteLine*)line;
- (YRouteLine*) getRouteLine:(int)index;
- (CLLocationCoordinate2D*) getPoints;
- (int) getPointCount;
- (void) getPointsArray:(NSMutableArray*) array;
- (YRoutePoint*) getBeginPoint;
- (YRoutePoint*) getLastPoint;

- (double) cmpLineAndPoint:(YRoutePoint*)p;
- (YRoutePoint*)getNearPoint:(YRoutePoint*)p;
- (YRoutePoint**) getSelectLine;
- (double) getMDistanceToNearPoint:(YRoutePoint*)gp;
- (double) getMDistancePointToPoint:(YRoutePoint*) sp Point:(YRoutePoint*) glp;
- (double) getMDistanceNearPointToPoint:(YRoutePoint*)sp Point:(YRoutePoint*)glp;
- (YRoutePoint*) getRoutePoint:(int)l_no PNo:(int)p_no;
- (YRouteLine*) getNowRLine;
- (double) getMTotalDistance;
- (double) getMTotalDistanceByLNo:(int)lno;
- (NSString*) getGuideMesageByLine:(YRouteLine*)line;
- (YRoutePoint*) getGuidePoint;
- (int) getNextDirection;
- (YRouteLine*) getNextRouteLine;

+(BOOL) intersectionScreenStart:(YRoutePoint*)p1 Goal:(YRoutePoint*)p2 TopLeft:(YRoutePoint*)p3 Width:(int)w Height:(int)h;
+(BOOL) intersectionSP1:(YRoutePoint*)p1 GP1:(YRoutePoint*)p2 SP2:(YRoutePoint*)p3 GP2:(YRoutePoint*)p4;
+(YRoutePoint*) getIntersectingPX:(double)px PY:(double)py LineSX:(double)line_sx  LineSY:(double)line_sy LineEX:(double)line_ex LineEY:(double)line_ey;
+(YRoutePoint*) getIntersectingPoint:(YRoutePoint*)pt SP:(YRoutePoint*)line_start GP:(YRoutePoint*)line_end;
+(double) getIntersectingDistPX:(double)px PY:(double)py SX:(double)line_sx SY:(double)line_sy EX:(double)line_ex EY:(double)line_ey;
+ (double) getIntersectingDistPoint:(YRoutePoint*)pt LineSP:(YRoutePoint*)line_start LineEP:(YRoutePoint*)line_end;

+(YRouteControl*)routeWithYdfJsonString:(NSString*)ydf;
+(BOOL)jsonResultInfoPuser:(NSDictionary*)ydf withYRouteControl:(YRouteControl*)yRouteControl;
+(BOOL)jsonFeaturePuser:(NSDictionary*)ydf withYRouteControl:(YRouteControl*)yRouteControl;
+(BOOL)jsonGeometryPuser:(NSDictionary*)ydf withYRouteLine:(YRouteLine*)routeLine;
+(BOOL)jsonRouteInfoPuser:(NSDictionary*)ydf withYRouteLine:(YRouteLine*)routeLine;

@end