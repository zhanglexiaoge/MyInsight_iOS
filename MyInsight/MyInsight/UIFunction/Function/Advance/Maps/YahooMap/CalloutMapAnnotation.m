//
//  CalloutMapAnnotation.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CalloutMapAnnotation.h"

@implementation CalloutMapAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate {
    _coordinate = coordinate;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (instancetype)initLocationCoordinate:(CLLocationCoordinate2D)locationCoordinate
{
    self = [super init];
    if (self) {
        self.coordinate = locationCoordinate;
    }
    return self;
}

@end
