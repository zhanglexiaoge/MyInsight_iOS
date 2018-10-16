//
//  YMKMapView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import "YMKAnnotationView.h"
#import "YMKGeometry.h"
#import "YMKTypes.h"
#import "MapDelegate.h"

@class YMKUserLocation;
@class YMKOverlayView;
@class YMKIndoormapOverlay;
@class MapCtrl;
@protocol YMKMapViewDelegate;
@protocol YMKOverlay;
@protocol YMKMapLayer;
@protocol YMKMapLayerDelegate;

@interface YMKMapView : UIView <MapDelegate>{
	MapCtrl* _internal;
	id <YMKMapViewDelegate> __weak delegate;
}

@property (nonatomic, weak) id <YMKMapViewDelegate> delegate;
@property (nonatomic) YMKMapType mapType;
- (void)setMapType:(YMKMapType)mapType MapStyle:(NSString*)mapStyle MapStyleParam:(NSArray*)mapStyleParam;
- (void)setMapType:(YMKMapType)mapType Level:(int)level;
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;
@property (nonatomic) YMKCoordinateRegion region;
- (void)setRegion:(YMKCoordinateRegion)region animated:(BOOL)animated;
@property (nonatomic, readonly) NSString* mapStyle;
@property (nonatomic, readonly) NSArray* mapStyleParam;

- (YMKCoordinateRegion)regionThatFits:(YMKCoordinateRegion)region;
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view;
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view;
- (CGRect)convertRegion:(YMKCoordinateRegion)region toRectToView:(UIView *)view;
- (YMKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view;

@property(nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;
@property(nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
@property(nonatomic, getter=isScalebarVisible) BOOL scalebarVisible;

@property (nonatomic) BOOL pinchEnabled;
@property (nonatomic) BOOL centerZoomEnabled;

@property (nonatomic) BOOL showsUserLocation;
@property (nonatomic, readonly) YMKUserLocation *userLocation;
@property (nonatomic, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;
@property (nonatomic) BOOL userLocationMarkVisible;

@property int scalebarValign;
@property int copyrightValign;

- (void) onTerminate;
- (void) onInActive;
- (void) onActive;

//アノテーション系
- (void)addAnnotation:(id <YMKAnnotation>)annotation;
- (void)addAnnotations:(NSArray *)annotations;
- (void)removeAnnotation:(id <YMKAnnotation>)annotation;
- (void)removeAnnotations:(NSArray *)annotations;
@property (nonatomic, readonly) NSArray *annotations;
- (YMKAnnotationView *)viewForAnnotation:(id <YMKAnnotation>)annotation;
- (YMKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;
- (void)selectAnnotation:(id <YMKAnnotation>)annotation animated:(BOOL)animated;
- (void)deselectAnnotation:(id <YMKAnnotation>)annotation animated:(BOOL)animated;
@property (nonatomic, copy) NSArray *selectedAnnotations;
@property (nonatomic, readonly) CGRect annotationVisibleRect;

//Overlay関係
@property (nonatomic, readonly) NSArray *overlays;
//オーバーレイを追加
- (void)addOverlay:(id < YMKOverlay >)overlay;
//オーバーレイ配列を追加
- (void)addOverlays:(NSArray *)overlays;
//オーバーレイ削除
- (void)removeOverlay:(id < YMKOverlay >)overlay;
//オーバーレイ配列削除
- (void)removeOverlays:(NSArray *)overlays;
//オーバーレイを追加
- (void)insertOverlay:(id < YMKOverlay >)overlay atIndex:(NSUInteger)index;
//オーバーレイの順番を入れ替える
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2;
//オーバーレイを挿入
- (void)insertOverlay:(id < YMKOverlay >)overlay aboveOverlay:(id < YMKOverlay >)sibling;
//オーバーレイを挿入
- (void)insertOverlay:(id < YMKOverlay >)overlay belowOverlay:(id < YMKOverlay >)sibling;
//オーバーレイからOverlayViewを取得
- (YMKOverlayView *)viewForOverlay:(id < YMKOverlay >)overlay;

//指定した画面座標に意図するタイル画像のIDなどを取得
//戻り値:int[0]タイルID_X int[1]タイルID_Y int[2]タイルID_Z int[3]タイル上でのX座標 int[4]タイル上でのY座標
- (int*) checkRangeX:(int)x Y:(int)y;

- (id)initWithFrame:(CGRect)frame appid:(NSString*) appid;

- (id)getAttestation;

//20110816
- (id<YMKMapLayer>)getMapLayerWithLocation:(CLLocationCoordinate2D)location mapLayerDelegate:(id <YMKMapLayerDelegate>)mapLayerDelegate;
- (int)getZoomlevel;
- (id<YMKMapLayer>)getMapLayerWithRegion:(YMKCoordinateRegion)region mapLayerDelegate:(id <YMKMapLayerDelegate>)mapLayerDelegate;

- (void)setSpaceId:(NSString*)spaceId;

- (YMKIndoormapOverlay*)createIndoormapOverlay;

-(void)setMaximumZoomLevel:(double)maximumZoomLevel;
@end

@protocol YMKMapViewDelegate <NSObject>
@optional

- (void)mapView:(YMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated;
- (void)mapView:(YMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated;

- (void)mapViewWillStartLoadingMap:(YMKMapView *)mapView;
- (void)mapViewDidFinishLoadingMap:(YMKMapView *)mapView;
- (void)mapViewDidFailLoadingMap:(YMKMapView *)mapView withError:(NSError *)error;

- (YMKAnnotationView *)mapView:(YMKMapView *)mapView viewForAnnotation:(id <YMKAnnotation>)annotation;

- (YMKOverlayView*)mapView:(YMKMapView*)mapView viewForOverlay:(id <YMKOverlay>)overlay;//Overlay追加時に発生

- (void)mapView:(YMKMapView *)mapView didAddAnnotationViews:(NSArray *)views;

- (void)mapView:(YMKMapView *)mapView annotationView:(YMKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

- (void)mapViewWillStartLocatingUser:(YMKMapView *)mapView;

- (void)mapViewDidStopLocatingUser:(YMKMapView *)mapView;

- (void)mapView:(YMKMapView *)mapView didUpdateUserLocation:(YMKUserLocation *)userLocation;

- (void)mapView:(YMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error;

- (void)mapView:(YMKMapView *)mapView longPressWithCoordinate:(CLLocationCoordinate2D)coordinate;

- (void)mapView:(YMKMapView *)mapView beganPressWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end