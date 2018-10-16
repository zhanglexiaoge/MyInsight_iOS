//
//  RunTimeVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "RunTimeVC.h"
#import <objc/runtime.h>

@interface RunTimeVC ()

// 输出
@property (weak, nonatomic) UITextView *inputTextView;

@end

@implementation RunTimeVC

#pragma mark - 运行时
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"运行时RunTime";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test];
}


- (void)test {
    // 定义JSON字典
    NSDictionary *userInfo = @{
                               @"class":@"RadioButtonVC",
                               @"property":@{
                                       @"ID":@"123",
                                       @"type":@"12",
                                       },
                               };
    
    [self push:userInfo];
}


- (void)push:(NSDictionary *)params {
    // 得到类名
    NSString *className = [NSString stringWithFormat:@"%@", params[@"class"]];
    // 通过名称转换成Class
    Class getClass = NSClassFromString([NSString stringWithFormat:@"%@", className]);
    
    // 判断得到这个Class 是否存在
    if (getClass) {
        // 创建Class对象
        id createClass = [[getClass alloc] init];
        // 优化
        NSDictionary *propertys = params[@"property"];
        [propertys enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([self checkIsExistPropertyWithInstance:createClass verifyPropertyName:key]) {
                // 利用KVC赋值
                NSLog(@"KEY值：%@", key);
                [createClass setValue:obj forKey:key];
            }
        }];
        // 跳转界面
        [self.navigationController pushViewController:createClass animated:YES];
    } else {
        NSLog(@"没有这个class 对象 无法跳转 ");
    }
}

- (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName {
    unsigned int outCount, i;
    // 获取对象里的属性列表
    objc_property_t *properties = class_copyPropertyList([instance class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =  properties[i];
        // 属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        NSLog(@"属性名 propertyName：%@", propertyName);
        // 判断属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    return NO;
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
