//
//  YMKIndoormapOverlayView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "YMKIndoormapOverlay.h"
#import "YMKOverlayView.h"
#import "YMKIndoormapOverlayDelegate.h"
#import "YMKTileOverlayView.h"

//#define YOLP_RELEASE

@interface YMKIndoormapOverlayView : YMKTileOverlayView
{
     id <YMKIndoormapOverlayDelegate> delegate;
}
@property (nonatomic) BOOL backgroundColorEnabled;
@property(nonatomic, assign) id <YMKIndoormapOverlayDelegate> delegate;

- (id)initWithOverlay:(YMKIndoormapOverlay *)overlay;
- (id)initWithIndoormapOverlay:(YMKIndoormapOverlay *)overlay;
- (void)updateOverlayView;
@end
