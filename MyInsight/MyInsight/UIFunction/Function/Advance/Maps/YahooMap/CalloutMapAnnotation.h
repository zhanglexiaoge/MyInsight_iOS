//
//  CalloutMapAnnotation.h
//  MyInsight
//
//  Created by SongMenglong on 2018/1/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YMapKit/YMKAnnotation.h>

@interface CalloutMapAnnotation : NSObject<YMKAnnotation>
//为吹泡泡 新添加的属性属性
@property (nonatomic, assign) CLLocationDegrees latitude;

@property (nonatomic, assign) CLLocationDegrees longitude;
//callout吹出框要显示的各信息
@property (nonatomic, strong) NSDictionary *locationInfo;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (instancetype)initLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate;

@end
