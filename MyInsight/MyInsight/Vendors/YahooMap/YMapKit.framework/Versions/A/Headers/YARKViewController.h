//
//  YARKViewController.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "EAGLView.h"
#import <CoreLocation/CoreLocation.h>
#import "ARPoint.h"
#import "NavigationMgr.h"
#import "SubmapView.h"
#import "POIView.h"

@protocol YARKViewDelegate;



@interface YARKViewController : UIViewController <NavigationMgrDelegate, YMKMapViewDelegate, POIViewDelegate> {	
	//ナビゲーションマネージャ
	NavigationMgr* nm;
	
	//カメラビュー
	UIImagePickerController *cameraController;
	
	//OpenGL関係
	EAGLView *ar_overlayView;
	EAGLContext *context;
	BOOL animating;
	NSInteger animationFrameInterval;
	CADisplayLink *displayLink;
	
	//サブマップ
	SubmapView* submap;
	UIImage* gpsIcon;
	
	int arrowA;
	int arrowR;
	int arrowG;
	int arrowB;
	
	//POIView
	POIView* poiView;
	
    //リスナー
    id<YARKViewDelegate> delegate;
    
	BOOL _visible;
}

//公開メソッド

//現在位置
//@property (nonatomic, readonly) CLLocationCoordinate2D curCoord;
- (void) setCurrentPos:(CLLocation*)loc;

//仰角
@property (nonatomic, readonly) float inclination;

//方位角
@property (nonatomic, readonly) float azimuth;

@property (nonatomic) int arrowA;
@property (nonatomic) int arrowR;
@property (nonatomic) int arrowG;
@property (nonatomic) int arrowB;

@property (assign) id<YARKViewDelegate> delegate;
@property (nonatomic, readonly) UIView* arOverlayView;

- (int) addPOI:(double) lat :(double) lon :(UIImage*) icon :(int) x :(int) y;
- (void) removePOI:(int) index;
- (void) clearPOI;
- (void) setDestination:(int) index;
- (void) setRoute:(NSArray*) route;
- (void) setRoute:(CLLocationCoordinate2D*) route Count:(int) cnt;
+ (BOOL) arViewControllerAvailable;
//20120117追加
- (BOOL) hide;	//ARビューを非表示にする
- (void) addView:(UIView*)value;


- (void) submapHidden:(BOOL)hide;
- (BOOL) isSubmapHidden;
- (void) showArView;
@end



@protocol YARKViewDelegate <NSObject>
@optional
- (void) touchPOI:(int)index;

@end
