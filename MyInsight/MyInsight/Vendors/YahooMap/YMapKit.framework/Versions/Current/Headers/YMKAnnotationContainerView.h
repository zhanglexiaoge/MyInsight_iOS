//
//  YMKAnnotationContainerView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKAnnotation.h"
#import "YMKAnnotationView.h"

//イベントデリゲート
@protocol YMKAnnotationContainerViewDelegate <NSObject>
@optional
- (YMKAnnotationView*)createViewForAnnotation:(id <YMKAnnotation>)annotation;//Overlay追加時に発生
- (void)iventAnnotationView:(YMKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;//ボタンクリック
@end

@interface YMKAnnotationContainerView : UIView
{
   	NSMutableArray* _annotations;	//Annotationリスト
   	NSMutableArray* _annotationViews;	//AnnotationViewリスト
	NSMutableArray* _waitAnnotations;	//アニメーションドロップ待ちannotationリスト
    NSMutableArray* _selectedAnnotations;
    id<YMKAnnotationContainerViewDelegate> _delegate;//デリゲート

	//デフォルトアイコン
	UIImage *pin_red;//赤
	UIImage *pin_green;//緑
	UIImage *pin_purple;//紫
    
    //アニメーション開始タイマー用
	NSTimer* _timer;
    
    //スケール
    double zoomScale;
    
    CGRect defRect;
}
@property(nonatomic, copy) NSArray *selectedAnnotations;
@property(nonatomic, readonly) CGRect annotationVisibleRect;
@property (nonatomic, readonly) NSArray *annotations;
@property (nonatomic) double zoomScale;
@property (nonatomic) CGRect defRect;

- (id)initWithFrame:(CGRect)frame withDelegate:(id<YMKAnnotationContainerViewDelegate>)delegate;
//注記をリストに追加
- (void)addAnnotation:(id <YMKAnnotation>)item;
//注記配列を取得
- (void)addAnnotations:(NSArray *)annotations;
//注記を削除
- (void)removeAnnotation:(id <YMKAnnotation>)annotation;
//複数の注記を削除
- (void)removeAnnotations:(NSArray *)annotations;
//AnnotationからAnnotationViewを検索
- (YMKAnnotationView*)viewForAnnotation:(id <YMKAnnotation>)annotation;
//Annotation
- (void)selectAnnotation:(id <YMKAnnotation>)annotation animated:(BOOL)animated;
//検索結果
- (void)deselectAnnotation:(id <YMKAnnotation>)annotation animated:(BOOL)animated;

- (void)deselectAnnotationExceptView:(YMKAnnotationView*)annotationView;

- (void)scrollViewDidZoom:(UIScrollView *)scrollView withTiledViewRect:(CGRect)rect;

//すべてのAnnotationを非選択状態に
- (void)deselectAnnotationAll;

- (void)iventAnnotationView:(YMKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale;
@end
