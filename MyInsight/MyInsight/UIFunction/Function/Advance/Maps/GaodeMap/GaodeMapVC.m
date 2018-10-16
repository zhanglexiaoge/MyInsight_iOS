//
//  GaodeMapVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/9/19.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "GaodeMapVC.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h> // 地图头文件SDK
#import <AMapLocationKit/AMapLocationKit.h> // 定位SDK
#import <Masonry.h>

@interface GaodeMapVC ()<MAMapViewDelegate, AMapLocationManagerDelegate>
// 地图视图
@property (nonatomic, strong) MAMapView *mapView;
// 定位管理者
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

#define AliMap_Appkey @"de792e7d817e7a2d8871930119a525f6"

@implementation GaodeMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"高德地图";
    
    // 设置key
    [[AMapServices sharedServices] setApiKey:AliMap_Appkey];
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    
    [self setupMapViews];
}

#pragma mark - 设置高德地图
- (void)setupMapViews {
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
    self.mapView.showsCompass = YES;
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.showsScale = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeNone;
    self.mapView.delegate = self;
    //self.mapView.rotateEnabled = YES;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.mapView setZoomLevel:(17.2f) animated:YES];
    //self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(22.547,114.085947);
    
    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;
    // 开始定位
    [self.locationManager startUpdatingLocation];
}

// 定位代理方法回调
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    //self.mapView.centerCoordinate
    NSLog(@"更新定位信息");
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"定位失败");
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
    NSLog(@"最新方法");
    self.mapView.centerCoordinate = location.coordinate;
}

// 大头针
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
//    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
//        CustomAnnotationView *annoView = [CustomAnnotationView annotationViewWithMap:mapView];
//        annoView.canShowCallout= YES;
//        annoView.draggable = YES;
//        annoView.annotation = annotation;
//        return annoView;
//
//    }
    return nil;
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
