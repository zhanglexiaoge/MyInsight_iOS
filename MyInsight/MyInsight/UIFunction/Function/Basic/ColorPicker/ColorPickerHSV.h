//
//  ColorPickerHSV.h
//  MyInsight
//
//  Created by SongMengLong on 2018/7/16.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#ifndef ColorPickerHSV_h
#define ColorPickerHSV_h

#include <stdio.h>

#endif /* ColorPickerHSV_h */

//code from http://www.cocoabuilder.com/archive/cocoa/198570-here-is-code-to-convert-rgb-hsb.html
#define UNDEFINED 0

typedef struct {float r, g, b;} RGBType;
typedef struct {float h, s, v;} HSVType;

// Theoretically, hue 0 (pure red) is identical to hue 6 in these transforms. Pure
// red always maps to 6 in this implementation. Therefore UNDEFINED can be
// defined as 0 in situations where only unsigned numbers are desired.
RGBType RGBTypeMake(float r, float g, float b);
HSVType HSVTypeMake(float h, float s, float v);

HSVType RGB_to_HSV( RGBType RGB );
RGBType HSV_to_RGB( HSVType HSV );

