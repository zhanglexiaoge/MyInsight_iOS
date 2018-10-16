//
//  BaiduMapVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/8.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "BaiduMapVC.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <Masonry.h>

@interface BaiduMapVC ()<BMKMapViewDelegate, BMKLocationServiceDelegate>
// 定位
@property (nonatomic, strong) BMKLocationService *service;
// 创建百度地图
@property (nonatomic, strong) BMKMapView *mapView;
// 多边形覆盖物
@property (nonatomic, strong) BMKPolygon *polygon;
// 百度地图
@property (nonatomic, strong) BMKMapManager *mapManager;
// 功能View
@property (nonatomic, strong) UIView *functionView;
// 定位
@property (nonatomic, strong) UIButton *locationButton;
// 绘制
@property (nonatomic, strong) UIButton *addButton;
// 清除
@property (nonatomic, strong) UIButton *clearButton;
// 大头针数组
@property (nonatomic, strong) NSMutableArray *annotationArray;

@end

@implementation BaiduMapVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"百度地图";
    
    self.mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [self.mapManager start:@"0nfzMkdFKsqy8yhXiri3QQEB"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图初始化失败！");
    }
    // 设置百度地图定位
    [self setupBaiduMapLocation];
    // 绘制页面
    [self setupFunctionView];
    // 初始化数组
    self.annotationArray = [[NSMutableArray alloc] init];
    
}

#pragma mark - 设置百度地图
- (void)setupBaiduMap {
    
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    self.mapView.delegate = self;
    //设置地图的显示样式
    self.mapView.mapType = BMKMapTypeSatellite; //卫星地图
    //设定地图是否打开路况图层
    self.mapView.trafficEnabled = YES;
    //底图poi标注
    self.mapView.showMapPoi = NO;
    //在手机上当前可使用的级别为3-21级
    self.mapView.zoomLevel = 19;
    
    //设定地图View能否支持用户移动地图
    self.mapView.scrollEnabled = NO;
    //添加到view上
    [self.view addSubview:self.mapView];
}

- (void)setupFunctionView {
    // 容器view
    self.functionView = [[UIView alloc] init];
    self.functionView.backgroundColor = [UIColor lightGrayColor];
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

// 定位button动作方法
- (void)locationButtonAction:(UIButton *)button {
    /*
     *打开定位服务
     *需要在info.plist文件中添加(以下二选一，两个都添加默认使用NSLocationWhenInUseUsageDescription)：
     *NSLocationWhenInUseUsageDescription 允许在前台使用时获取GPS的描述
     *NSLocationAlwaysUsageDescription 允许永远可获取GPS的描述
     * iOS开发 Xcode8中遇到的问题及改动 http://www.jianshu.com/p/90d5323cf510
     */
    NSLog(@"定位button");
    //初始化定位
    self.service = [[BMKLocationService alloc] init];
    //设置代理
    self.service.delegate = self;
    //开启定位
    [self.service startUserLocationService];
    
    //NSLog(@"初始化 处理位置更新 定位的经纬度:%f %f", self.service.userLocation.location.coordinate.latitude, self.service.userLocation.location.coordinate.longitude);
}
// 添加覆盖物button动作方法
- (void)addButtonAction:(UIButton *)button {
    NSLog(@"添加button");
    // 数组转换成结构体 初始化结构体
    if (self.annotationArray.count <= 2) {
        NSLog(@"选中坐标太少了");
        return;
    }
    
    CLLocationCoordinate2D coords[100] = {0};
    for (int i = 0; i < self.annotationArray.count; i++) {
        BMKPointAnnotation *pointAnnotation = [self.annotationArray objectAtIndex:i];
        coords[i] = pointAnnotation.coordinate;
    }
    // 生成多边形
    self.polygon = [BMKPolygon polygonWithCoordinates:coords count:self.annotationArray.count];
    // 添加到层
    [self.mapView addOverlay:self.polygon];
}
// 清除覆盖物button动作方法
- (void)clearButtonAction:(UIButton *)button {
    NSLog(@"清除button");
    
    // 移除覆盖层
    [self.mapView removeOverlay:self.polygon];
    // 移除大头针数组
    [self.mapView removeAnnotations:self.annotationArray];
    // 数组清空
    [self.annotationArray removeAllObjects];
}

// 设置百度地图定位
- (void)setupBaiduMapLocation {
    //初始化地图
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
    // 设置代理
    self.mapView.delegate = self;
    // 地图可交互
    self.mapView.userInteractionEnabled = YES;
    //设定地图View能否支持旋转
    self.mapView.rotateEnabled = NO;
    // 地图显示等级
    self.mapView.zoomLevel = 14;
    //添加到view上
    [self.view addSubview:self.mapView];
}

#pragma mark - 实现相关delegate 处理位置信息更新
// 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    // 展示定位
    self.mapView.showsUserLocation = YES;
    // 更新位置数据
    [self.mapView updateLocationData:userLocation];
    // 获取用户的坐标
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    //NSLog(@"处理位置更新 定位的经纬度:%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
}

- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"地图定位失败======%@",error);
}

#pragma mark - MapView的Delegate，mapView通过此类来通知用户对应的事件
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    NSLog(@"加载完 处理位置更新 定位的经纬度:%f %f", self.service.userLocation.location.coordinate.latitude, self.service.userLocation.location.coordinate.longitude);
    NSLog(@"加载完地图");
}

//
- (void)mapStatusDidChanged:(BMKMapView *)mapView {
    //NSLog(@"地图状态改变");
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate {
    NSLog(@"点击地图响应坐标: %f %f", coordinate.latitude, coordinate.longitude);
    
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc]init];
    pointAnnotation.coordinate = coordinate;
    pointAnnotation.title = @"覆盖物";
    pointAnnotation.subtitle = @"覆盖物坐标啊，点击了吧";
    // 添加大头针
    [self.mapView addAnnotation:pointAnnotation];
    // 添加到数组啊啊
    [self.annotationArray addObject:pointAnnotation];
}

- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"双击地图响应坐标: %f %f", coordinate.latitude, coordinate.longitude);
}

- (void)mapview:(BMKMapView *)mapView onLongClick:(CLLocationCoordinate2D)coordinate {
    NSLog(@"长按地图响应坐标: %f %f", coordinate.latitude, coordinate.longitude);
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view {
    NSLog(@"点击泡泡");
}

// 覆盖物
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolygon class]]) {
        
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor alloc] initWithRed:0.0 green:0 blue:0.5 alpha:1];
        polygonView.fillColor = [[UIColor alloc] initWithRed:0 green:1 blue:1 alpha:0.2];
        polygonView.lineWidth =2.0;
        polygonView.lineDash = (overlay == self.polygon);
        return polygonView;
    }
    return nil;
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
