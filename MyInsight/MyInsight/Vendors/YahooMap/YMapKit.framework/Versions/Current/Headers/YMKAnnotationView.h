//
//  YMKAnnotationView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import "YMKGeometry.h"
#import "YMKAnnotation.h"

@class YMKCalloutView;

@interface YMKAnnotationView : UIView{
	NSString *reuseIdentifier;
	id <YMKAnnotation> annotation;
	UIImage *image;
	CGPoint centerOffset;
	CGPoint calloutOffset;
	CGPoint centerOffsetShadow;
	BOOL enabled;
	BOOL highlighted;
	BOOL selected;
	BOOL canShowCallout;
	UIView *leftCalloutAccessoryView;
	UIView *rightCalloutAccessoryView;
	UIImageView *shadowView;
	BOOL _popBackVisible;
    YMKMapPoint mapPoint;
    YMKCalloutView* _calloutView;
}

//初期化
- (id)initWithAnnotation:(id <YMKAnnotation>)wkannotation reuseIdentifier:(NSString *)_reuseIdentifier;


-(void)resetAnnotaion;

-(void)rotateTransform:(double)radian;


@property (nonatomic, readonly) NSString *reuseIdentifier;
	
- (void)prepareForReuse;
	
@property (nonatomic, retain) id <YMKAnnotation> annotation;
	
@property (nonatomic,retain) UIImage *image;

@property (nonatomic) CGPoint centerOffset;

@property (nonatomic) CGPoint calloutOffset;

@property (nonatomic, getter=isEnabled) BOOL enabled;
	
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
	
@property (nonatomic, getter=isSelected) BOOL selected;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
	
@property (nonatomic) BOOL canShowCallout;
	
@property (retain, nonatomic) UIView *leftCalloutAccessoryView;
	
@property (retain, nonatomic) UIView *rightCalloutAccessoryView;

- (void)setImageShadow:(UIImage*)imageShadow withCenterOffset:(CGPoint)offset;

@property BOOL popBackVisible;

@property (nonatomic) YMKMapPoint mapPoint;

@end