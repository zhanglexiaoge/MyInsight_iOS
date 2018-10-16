//
//  YMKGeometry.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//				
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>	

typedef struct {		
    CLLocationDegrees latitudeDelta;
    CLLocationDegrees longitudeDelta;
} YMKCoordinateSpan;	

typedef struct {
	CLLocationCoordinate2D center;
	YMKCoordinateSpan span;
} YMKCoordinateRegion;


UIKIT_STATIC_INLINE YMKCoordinateSpan YMKCoordinateSpanMake(CLLocationDegrees latitudeDelta, CLLocationDegrees longitudeDelta)
{
    YMKCoordinateSpan span;
    span.latitudeDelta = latitudeDelta;
    span.longitudeDelta = longitudeDelta;
    return span;
}

UIKIT_STATIC_INLINE YMKCoordinateRegion YMKCoordinateRegionMake(CLLocationCoordinate2D centerCoordinate, YMKCoordinateSpan span)
{			
	YMKCoordinateRegion region;
	region.center = centerCoordinate;
	region.span = span;	
	return region;		
}						

//4.0					
typedef struct {		
	double x;			
	double y;			
} YMKMapPoint;			
						
typedef struct {
	double width;
	double height;
} YMKMapSize;

typedef struct {
	YMKMapPoint origin;
	YMKMapSize size;
} YMKMapRect;

typedef double YMKZoomScale;

UIKIT_STATIC_INLINE YMKMapRect YMKMapRectMake(double left, double top, double width, double height)
{
    YMKMapRect rect;
    rect.origin.x = left;
    rect.origin.y = top;
    rect.size.width = width;
    rect.size.height = height;
    return rect;
}

UIKIT_STATIC_INLINE YMKMapPoint YMKMapPointMake(double x, double y)
{
    YMKMapPoint point;
    point.x = x;
    point.y = y;
    return point;
}
CLLocationCoordinate2D YMKCoordinateForMapPoint(YMKMapPoint mapPoint);
YMKMapPoint YMKMapPointForCoordinate(CLLocationCoordinate2D coordinate);

