//
//  POIView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import "NavigationMgr.h"

@protocol POIViewDelegate;

@interface POIView : UIView {
	NavigationMgr* naviMgr;
	id<POIViewDelegate> delegate;
}
@property (nonatomic, retain) NavigationMgr* naviMgr;
@property (assign) id<POIViewDelegate> delegate;
- (void) updateLocation;
@end

@protocol POIViewDelegate <NSObject>
- (void) poiView:(POIView*)poiView onPick:(int)index;
@end