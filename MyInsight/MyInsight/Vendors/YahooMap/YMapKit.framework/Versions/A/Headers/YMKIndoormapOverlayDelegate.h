//
//  YMKWeatherOverlayDelegate.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//

#import <Foundation/Foundation.h>
@class YMKIndoormapOverlayView;

@protocol YMKIndoormapOverlayDelegate <NSObject>

// 1画面分の屋内地図描画が完了した時に処理を返す
- (void)finishUpdateIndoormap:(YMKIndoormapOverlayView *)indoormapOverlayView;
// 屋内地図更新時のエラーが発生した時に処理を返す
- (void)errorUpdateIndoormap:(YMKIndoormapOverlayView *)indoormapOverlayView withError:(int)error;
@end
