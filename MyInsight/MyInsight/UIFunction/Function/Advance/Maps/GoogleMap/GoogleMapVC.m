//
//  GoogleMapVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/8.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "GoogleMapVC.h"
#import <GoogleMaps/GoogleMaps.h> //引入谷歌地图



@interface GoogleMapVC ()

@end

@implementation GoogleMapVC

/*
 谷歌地图
 [iOS Google地图SDK入门教程](https://www.jianshu.com/p/dc7d267d63d0)
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"谷歌地图";
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
