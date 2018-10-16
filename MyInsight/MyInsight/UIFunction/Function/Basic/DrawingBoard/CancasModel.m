//
//  CancasModel.m
//  MyInsight
//
//  Created by SongMengLong on 2018/6/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CancasModel.h"

@implementation CancasModel

-(void)setRed:(NSNumber*)r green:(NSNumber*)g blue:(NSNumber*)b {
    self.red = r;
    self.green = g;
    self.blue = b;
}

-(void)setRed:(NSNumber*)r green:(NSNumber*)g blue:(NSNumber*)b size:(NSNumber*)s{
    [self setRed:r green:g blue:b];
    self.size = s;
}

- (id)currentState{
    return @{@"red":_red,
             @"green":_green,
             @"blue":_blue,
             @"size":_size};
}

- (void)recoverFromState:(id)state{
    NSDictionary* dict = state;
    
    self.red = dict[@"red"];
    self.green = dict[@"green"];
    self.blue = dict[@"blue"];
    self.size = dict[@"size"];
}

-(UIColor*)getModelColor{
    return [[UIColor alloc] initWithRed:[self.red floatValue] green:[self.green floatValue] blue:[self.blue floatValue] alpha:1];
}

-(CGFloat)getModelSize{
    return [self.size floatValue];
}

@end
