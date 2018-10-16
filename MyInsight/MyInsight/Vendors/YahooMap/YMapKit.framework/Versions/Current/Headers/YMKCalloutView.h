//
//  TabView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>

@interface PopWinView : UIView{
	bool _offset_flag;
}
- (id)initWithFrame:(CGRect)frame;
- (void) CGContextFillStrokeRoundedRectCGContextRef:(CGContextRef)context Rect:(CGRect)rect  Radius:(CGFloat)radius;
@end

@interface YMKCalloutView : UIView{
	NSTimer* _timer; //アニメーション用
	double _scale; //表示の際の拡縮率
	
	UILabel* _title_lbl;
	UILabel* _sub_tile_lbl;
	
	double _cx; //中央 X座標
	double _cy; //中央 Y座標
	
	double _sc_width; //画面の横サイズ
	double _sc_height; //画面の縦サイズ
	
	int _width;
	
	PopWinView* _popWinView;
	
	BOOL _backVisible;
    
    NSString* _title;
    NSString* _subTitle;
    
}
@property BOOL backVisible;

//初期化
- (id)initWithPos:(double)X :(double)Y :(int)SC_WIDTH :(int)SC_HEIGHT :(NSString*)title :(NSString*)subTitle :(UIView*)leftView :(UIView*)rightView;

//表示レベル
- (int)getLevel;

//アイテムタイプ
- (int)getItemType;

- (UIView*)getView;

- (void)animetion_init;

- (void)resetState;

- (void)removeAnimetion_init;

- (int)getWidthEx;

@end



