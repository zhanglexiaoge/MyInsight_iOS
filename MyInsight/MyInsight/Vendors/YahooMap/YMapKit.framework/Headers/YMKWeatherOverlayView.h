//
//  YMKWeatherOverlayView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "YMKWeatherOverlay.h"
#import "YMKOverlayView.h"
#import "YMKWeatherOverlayDelegate.h"
#import "YMKTileOverlayView.h"

//#define YOLP_RELEASE

@interface YMKWeatherOverlayView : YMKTileOverlayView
{
    @public
     NSDate *nowDate;
     id <YMKWeatherOverlayDelegate> delegate;
}
@property(nonatomic, assign, readonly) NSDate *nowDate;
@property(nonatomic, assign) id <YMKWeatherOverlayDelegate> delegate;

- (id)initWithOverlay:(YMKWeatherOverlay *)overlay;
- (id)initWithWeatherOverlay:(YMKWeatherOverlay *)overlay;

// 最新の天気データから引数minutesで指定されただけ過去/未来の天気データに更新する
- (void)updateWeatherWithMinutes:(int)minutes;

// 最新の天気データ(現在時刻から10分前)に更新する
- (void)updateWeather;

// 天気データを5分間隔で自動更新する
- (void)startAutoUpdate;
// 天気データを引数minutesで指定された間隔で自動更新する
- (void)startAutoUpdateWithInterval:(int)minutes;
// 自動更新している時、自動更新を停止する
- (void)stopAutoUpdate;
@end
