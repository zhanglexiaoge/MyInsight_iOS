//
//  YMKAnnotation.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>		
#import <CoreLocation/CoreLocation.h>	

//アイテム検索
@protocol YMKAnnotation <NSObject>

//アイテムの緯度経度
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@optional

// Title and subtitle for use by selection UI.
- (NSString *)title; //タイトル			
- (NSString *)subtitle; //サブタイトル

//4.0から追加
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end								
/*									
@interface Item : NSObject{	
	//					
}*/						
						