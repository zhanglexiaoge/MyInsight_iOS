//
//  SystemMapVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/8.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "SystemMapVC.h"
// 原声地图头文件
#import <MapKit/MapKit.h>
// 核心定位服务头文件
#import <CoreLocation/CoreLocation.h>
#import <Masonry.h>

@interface SystemMapVC ()<MKMapViewDelegate, CLLocationManagerDelegate>
// 定位
@property (nonatomic, strong) CLLocationManager *locationManager;
// 地图
@property (nonatomic, strong) MKMapView *mapView;
// 功能View
@property (nonatomic, strong) UIView *functionView;
// 定位button
@property (nonatomic, strong) UIButton *locationButton;
// 绘制添加button
@property (nonatomic, strong) UIButton *addButton;
// 清除button
@property (nonatomic, strong) UIButton *clearButton;

@end

@implementation SystemMapVC

/*
 准备仿照苹果手机自带地图软件写
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
     [iOS 自带地图详解](https://www.cnblogs.com/hongyan1314/p/5802193.html)
     */
    self.title = @"系统地图";
    
    // 创建地图
    [self creatMaps];
    // 定义容器view
    [self setupFunctionView];
    // 定位当前
    //[self selfLocation];
}

- (void)setupFunctionView {
    // 容器view
    self.functionView = [[UIView alloc] init];
    self.functionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.functionView];
    // 定位button
    self.locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.locationButton setTitle:@"定位" forState:UIControlStateNormal];
    self.locationButton.backgroundColor = [UIColor purpleColor];
    self.locationButton.layer.masksToBounds = YES;
    self.locationButton.layer.cornerRadius = 5.0f;
    [self.locationButton addTarget:self action:@selector(locationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:self.locationButton];
    // 添加button
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    self.addButton.backgroundColor = [UIColor greenColor];
    self.addButton.layer.masksToBounds = YES;
    self.addButton.layer.cornerRadius = 5.0f;
    [self.addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:self.addButton];
    // 清除button
    self.clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.clearButton setTitle:@"清除" forState:UIControlStateNormal];
    self.clearButton.backgroundColor = [UIColor magentaColor];
    self.clearButton.layer.masksToBounds = YES;
    self.clearButton.layer.cornerRadius = 5.0f;
    [self.clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.functionView addSubview:self.clearButton];
    
    // 代码约束
    // 功能容器页面
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44.0f+20.0f); // 高度
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.height.offset(40.0f);
    }];
    // 定位
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.functionView.mas_top).offset(0.0f);
        make.bottom.equalTo(self.functionView.mas_bottom).offset(0.0f);
        make.right.equalTo(self.addButton.mas_left).offset(0.0f);
        make.width.offset(60.0f);
    }];
    // 添加
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.functionView.mas_top).offset(0.0f);
        make.bottom.equalTo(self.functionView.mas_bottom).offset(0.0f);
        make.right.equalTo(self.clearButton.mas_left).offset(0.0f);
        make.width.offset(60.0f);
    }];
    // 清除
    [self.clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.functionView.mas_top).offset(0.0f);
        make.bottom.equalTo(self.functionView.mas_bottom).offset(0.0f);
        make.right.equalTo(self.functionView.mas_right).offset(0.0f);
        make.width.offset(60.0f);
    }];
}

// 创建地图
- (void)creatMaps {
    
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    // 需要设置 否则Painter Z index: 1023 is too large (max 255)
    self.mapView.visibleMapRect = MKMapRectMake(self.mapView.bounds.origin.x, self.mapView.bounds.origin.y, self.mapView.bounds.size.width, self.mapView.bounds.size.height);
    
    self.mapView.delegate = self;
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.showsUserLocation = YES;
    
    [self.view addSubview:self.mapView];
}



// 定位自己
- (void)selfLocation {
    // 创建定位对象
    self.locationManager = [[CLLocationManager alloc] init];
    // 设置定位属性
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //
    self.locationManager.distanceFilter = 10.0f;
    self.locationManager.delegate = self;
    // 1.去info.plist文件添加定位服务描述,设置的内容可以在显示在定位服务弹出的提示框
    //取出当前应用的定位服务状态(枚举值)
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    //如果未授权则请求
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"开始");
        [self.locationManager requestAlwaysAuthorization];
    }
    // 开始定位
    [self.locationManager startUpdatingLocation];
    
}

// 定位button动作方法
- (void)locationButtonAction:(UIButton *)button {
    NSLog(@"定位button");
}
// 添加覆盖物button动作方法
- (void)addButtonAction:(UIButton *)button {
    NSLog(@"添加button");
}
// 清除覆盖物button动作方法
- (void)clearButtonAction:(UIButton *)button {
    NSLog(@"清除button");
    
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    NSLog(@"加载完地图");
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"啦啦啦啦");
    //self.mapView.visibleMapRect = MKMapRectMake(self.mapView.bounds.origin.x, self.mapView.bounds.origin.y, self.mapView.bounds.size.width, self.mapView.bounds.size.height);
}

// 大头针回调方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    return NULL;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    return NULL;
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
