//
//  YMKWeatherOverlayDelegate.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
@class YMKWeatherOverlayView;

@protocol YMKWeatherOverlayDelegate <NSObject>

// 1画面分の天気データ描画が完了した時に処理を返す
- (void)finishUpdateWeather:(YMKWeatherOverlayView *)weatherOverlayView;
// 天気データ更新時のエラーが発生した時に処理を返す
- (void)errorUpdateWeather:(YMKWeatherOverlayView *)weatherOverlayView withError:(int)error;
@end
