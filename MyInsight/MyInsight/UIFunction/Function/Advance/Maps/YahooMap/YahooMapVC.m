//
//  YahooMapVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "YahooMapVC.h"
#import <YMapKit/YMapKit.h>
#import "CustomPointAnnotation.h"
#import "CalloutMapAnnotation.h"
#import "CallOutAnnotationView.h"

@interface YahooMapVC ()<YMKMapViewDelegate>

@property (nonatomic, strong) YMKMapView *yahooMap;
@property (nonatomic, strong) CalloutMapAnnotation *calloutMapAnnotation;

@end

@implementation YahooMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"雅虎地图";
    
    // 创建Yahoo地图
    [self creatYahooMap];
}

#pragma mark 创建Yahoo地图
- (void)creatYahooMap {
    // key
    NSString *YAHOO_APP_KEY = @"dj0zaiZpPXNUeEh5WHNZYkFzUyZzPWNvbnN1bWVyc2VjcmV0Jng9NmQ-";
    // 初始化地图
    self.yahooMap = [[YMKMapView alloc] initWithFrame:self.view.bounds appid:YAHOO_APP_KEY];
    self.yahooMap.mapType = YMKMapTypeStandard;
    self.yahooMap.showsUserLocation = YES;
    self.yahooMap.delegate = self;
    // 赋值给地图
    self.view = self.yahooMap;
    
    // 东京塔
    CLLocationCoordinate2D center;
    center.latitude = 35.665818701569016;
    center.longitude = 139.73087297164147;
    
    self.yahooMap.centerCoordinate = center;
    self.yahooMap.region = YMKCoordinateRegionMake(center, YMKCoordinateSpanMake(0.002, 0.002));
    
    [self.yahooMap invalidateIntrinsicContentSize];
    
    // 大头针泡泡的初始化
    CustomPointAnnotation *pointAnnotation = [[CustomPointAnnotation alloc] initWithLocationCoordinate:center title:NULL subtitle:NULL];
    // 添加大头针泡泡
    [self.yahooMap addAnnotation:pointAnnotation];
}

#pragma mark 实现Yahoo代理协议
// 自定义弹出的泡泡
- (YMKAnnotationView *)mapView:(YMKMapView *)mapView viewForAnnotation:(id<YMKAnnotation>)annotation  {
    NSString *annotationIdentifier = @"customAnnotation";
    
    if ([annotation isKindOfClass:[CustomPointAnnotation class]]) {
        YMKPinAnnotationView *annotationview = [[YMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        annotationview.image = [UIImage imageNamed:@"pin_red_s"];
        annotationview.animatesDrop = YES;
        // 添加手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(annotationviewSelcet:)];
        [annotationview addGestureRecognizer:tapGesture];
        NSLog(@"弹出自定义泡泡1");
        return annotationview;
    } else {
        CalloutMapAnnotation *ann = (CalloutMapAnnotation *)annotation;
        CallOutAnnotationView *calloutannotationview = [[CallOutAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:@"calloutview"];
        NSLog(@"弹出自定义泡泡2");
        return calloutannotationview;
    }
}

- (void)annotationviewSelcet:(UITapGestureRecognizer *)sender {
    NSLog(@"添加点击手势");
    YMKAnnotationView *view = (YMKAnnotationView *)sender.view;
    
    self.calloutMapAnnotation = [[CalloutMapAnnotation alloc] initLocationCoordinate:view.annotation.coordinate];
    
    NSMutableArray *annotationArray = [NSMutableArray arrayWithArray:self.yahooMap.annotations];
    if (annotationArray.count > 1) {
        [annotationArray removeLastObject];
        return;
    } else {
        CGPoint centerPoint = [self.yahooMap convertCoordinate:self.yahooMap.centerCoordinate toPointToView:self.yahooMap];
        self.yahooMap.centerCoordinate = [self.yahooMap convertPoint:CGPointMake(centerPoint.x, -centerPoint.y/2) toCoordinateFromView:sender.view];
        
        CLLocationCoordinate2D changeCenterCoordinate = [self.yahooMap convertPoint:CGPointMake(centerPoint.x/12, -centerPoint.y/2) toCoordinateFromView:sender.view];
        self.yahooMap.centerCoordinate = CLLocationCoordinate2DMake(self.yahooMap.centerCoordinate.latitude, changeCenterCoordinate.longitude);
        
        [self.yahooMap addAnnotation:self.calloutMapAnnotation];
    }
}

- (void)mapView:(YMKMapView *)mapView annotationView:(YMKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

- (void)mapView:(YMKMapView *)mapView beganPressWithCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"点击地图");
}

- (void)mapView:(YMKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    NSLog(@"添加大头针");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
