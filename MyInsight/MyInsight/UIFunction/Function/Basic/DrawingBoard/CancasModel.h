//
//  CancasModel.h
//  MyInsight
//
//  Created by SongMengLong on 2018/6/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CancasModel : NSObject

/** red */
@property (nonatomic, strong) NSNumber *red;
/** green */
@property (nonatomic, strong) NSNumber *green;
/** blue */
@property (nonatomic, strong) NSNumber *blue;
/** stroke size */
@property (nonatomic, strong) NSNumber *size;

- (void)setRed:(NSNumber *)r green:(NSNumber *)g blue:(NSNumber *)b;
- (void)setRed:(NSNumber *)r green:(NSNumber *)g blue:(NSNumber *)b  size:(NSNumber *)s;

- (UIColor *)getModelColor;

- (CGFloat)getModelSize;

@end
