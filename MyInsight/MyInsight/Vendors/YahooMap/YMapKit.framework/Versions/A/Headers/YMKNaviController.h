//
//  YMKNaviControler.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//		
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class YMKMapView;
@class YMKRouteOverlay;
@class YMKUserLocation;
@class YARKViewController;
@protocol YMKNaviControllerDelegate;
@protocol YMKAnnotation;
@protocol YMKRouteNodeInfo;

@interface YMKNaviController : NSObject <CLLocationManagerDelegate> {
	YMKMapView * _mapView;
	YARKViewController* _arViewController;
	YMKRouteOverlay * _routeOverlay;
	id <YMKNaviControllerDelegate> delegate;
	CLLocationManager* _locationMgr;
	CLLocationCoordinate2D _nowCoordinate;
	int _routeOutCnt;
	double _startGpsTime;
	double _startRemainderDistance;
	double _oldRemainderDistance;
	long _speed;
	BOOL _goalFlag;
	float _azimuth;
	
    UIImage* _routeIconImage;
    
	NSTimer *_tm;
	int _dev_index;
	NSMutableArray* _devLocationArray;
	id <YMKAnnotation> _usrLocAnnotation;
}

@property (nonatomic, assign) id <YMKNaviControllerDelegate> delegate;

-(id)initWithRouteOverlay:(YMKRouteOverlay *)routeOverlay;
-(BOOL)start;
-(BOOL)stop;
-(double)getDistanceOfRemainder;
-(double) getTotalDistance;
-(double) getRemainderDistance;
-(double) getTimeOfRemainder;
-(double) getTotalTime;

-(CLLocationCoordinate2D)getNowPointByCoordinate;
-(void)checkSpeed;

-(void)setARKViewController:(YARKViewController*)arViewController;
-(void)setMapView:(YMKMapView*)mapView;
-(id<YMKRouteNodeInfo>)getNextNodeInfo;
-(id<YMKRouteNodeInfo>)getCurrentNodeInfo;

@end	
		
@protocol YMKNaviControllerDelegate <NSObject>
@optional
-(void)naviController:(YMKNaviController*)naviController didUpdateUserLocation:(YMKUserLocation *)userLocation;
-(void)naviController:(YMKNaviController*)naviController didFailToLocateUserWithError:(NSError *)error;
-(void)naviControllerAccuracyBad:(YMKNaviController*)naviController didUpdateUserLocation:(YMKUserLocation *)userLocation;
-(void)naviControllerRouteOut:(YMKNaviController*)naviController didUpdateUserLocation:(YMKUserLocation *)userLocation;
-(void)naviControllerOnGoal:(YMKNaviController*)naviController didUpdateUserLocation:(YMKUserLocation *)userLocation;
@end	