
//
//  CoreGraphicsVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CoreGraphicsVC.h"
#import "BasicDrawingVC.h"
#import "DownloadProgressVC.h"
#import "PieChartVC.h"
#import "HistogramVC.h"
#import "ImageAndTextVC.h"
#import "SnowTimerVC.h"
#import "ImageContextStackVC.h"
#import "MatrixOperationVC.h"
#import "ImageWaterMarkVC.h"
#import "CorpImageVC.h"
#import "ScreenShotVC.h"
#import "CutOutImageVC.h"
#import "ImageErasureVC.h"
#import "DrawingVC.h"
#import "JiugonggeUnlockVC.h"

@interface CoreGraphicsVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

static const NSString *BasicDrawingStr = @"基本图形绘制";
static const NSString *DownloadProgressStr = @"下载进度";
static const NSString *PieChartStr = @"画饼图";
static const NSString *HistogramStr = @"柱状图";
static const NSString *ImageAndTextStr = @"图片和文字";
static const NSString *SnowTimerStr = @"下雪定时器";
static const NSString *ImageContextStackStr = @"图形上下文栈";
static const NSString *MatrixOperationStr = @"矩阵操作";
static const NSString *ImageWaterMarkStr = @"图片水印";
static const NSString *CorpImageStr = @"裁剪图片";
static const NSString *ScreenShotStr = @"截屏";
static const NSString *CutOutImageStr = @"截取图片";
static const NSString *ImageErasureStr = @"图片擦除";
static const NSString *DrawingStr = @"绘图";
static const NSString *JiugonggeUnlockStr = @"九宫格解锁";

@implementation CoreGraphicsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绘画2D";
    
    self.dataArray = @[BasicDrawingStr, DownloadProgressStr, PieChartStr, HistogramStr, ImageAndTextStr, SnowTimerStr, ImageContextStackStr, MatrixOperationStr, ImageWaterMarkStr, CorpImageStr, ScreenShotStr, CutOutImageStr, ImageErasureStr, DrawingStr, JiugonggeUnlockStr];
    
    [self creatTableView];
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 清除多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    // 赋值
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取到当前cell的字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([cellString isEqual:BasicDrawingStr]) {
        // 基本图形绘制
        BasicDrawingVC *basicDrawingVC = [[BasicDrawingVC alloc] init];
        basicDrawingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:basicDrawingVC animated:YES];
    }
    if ([cellString isEqual:DownloadProgressStr]) {
        // 下载进度
        DownloadProgressVC *downloadProgressVC = [[DownloadProgressVC alloc] init];
        downloadProgressVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:downloadProgressVC animated:YES];
    }
    if ([cellString isEqual:PieChartStr]) {
        // 画饼图
        PieChartVC *pieChartVC = [[PieChartVC alloc] init];
        pieChartVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pieChartVC animated:YES];
    }
    if ([cellString isEqual:HistogramStr]) {
        // 柱状图
        HistogramVC *histogramVC = [[HistogramVC alloc] init];
        histogramVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:histogramVC animated:YES];
    }
    if ([cellString isEqual:ImageAndTextStr]) {
        // 图片和文字
        ImageAndTextVC *imageAndTextVC = [[ImageAndTextVC alloc] init];
        imageAndTextVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:imageAndTextVC animated:YES];
    }
    if ([cellString isEqual:SnowTimerStr]) {
        // 下雪定时器
        SnowTimerVC *snowTimerVC = [[SnowTimerVC alloc] init];
        snowTimerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:snowTimerVC animated:YES];
    }
    if ([cellString isEqual:ImageContextStackStr]) {
        // 图形上下文栈
        ImageContextStackVC *imageContextStackVC = [[ImageContextStackVC alloc] init];
        imageContextStackVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:imageContextStackVC animated:YES];
    }
    if ([cellString isEqual:MatrixOperationStr]) {
        // 矩阵操作
        MatrixOperationVC *matrixOperationVC = [[MatrixOperationVC alloc] init];
        matrixOperationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:matrixOperationVC animated:YES];
    }
    if ([cellString isEqual:ImageWaterMarkStr]) {
        // 图片水印
        ImageWaterMarkVC *imageWaterMarkVC = [[ImageWaterMarkVC alloc] init];
        imageWaterMarkVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:imageWaterMarkVC animated:YES];
    }
    if ([cellString isEqual:CorpImageStr]) {
        // 裁剪图片
        CorpImageVC *corpImageVC = [[CorpImageVC alloc] init];
        corpImageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:corpImageVC animated:YES];
    }
    if ([cellString isEqual:ScreenShotStr]) {
        // 截屏
        ScreenShotVC *screenShotVC = [[ScreenShotVC alloc] init];
        screenShotVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:screenShotVC animated:YES];
    }
    if ([cellString isEqual:CutOutImageStr]) {
        // 截图图片
        CutOutImageVC *cutOutImageVC = [[CutOutImageVC alloc] init];
        cutOutImageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:cutOutImageVC animated:YES];
    }
    if ([cellString isEqual:ImageErasureStr]) {
        // 图片擦除
        ImageErasureVC *imageErasureVC = [[ImageErasureVC alloc] init];
        imageErasureVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:imageErasureVC animated:YES];
    }
    if ([cellString isEqual:DrawingStr]) {
        // 绘图
        DrawingVC *drawingVC = [[DrawingVC alloc] init];
        drawingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:drawingVC animated:YES];
    }
    if ([cellString isEqual:JiugonggeUnlockStr]) {
        // 九宫格解锁
        JiugonggeUnlockVC *jiugonggeUnlockVC = [[JiugonggeUnlockVC alloc] init];
        jiugonggeUnlockVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:jiugonggeUnlockVC animated:YES];
    }
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
