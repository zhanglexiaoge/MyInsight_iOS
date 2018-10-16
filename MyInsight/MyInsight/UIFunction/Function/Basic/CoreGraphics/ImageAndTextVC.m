//
//  ImageAndTextVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ImageAndTextVC.h"

@interface ImageAndTextVC ()

@end

@implementation ImageAndTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片和文字";
    
    [self redView];
}

- (Class)drawViewClass {
    return [ImageAndTextView class];
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

@implementation ImageAndTextView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    // 超出裁剪区域的内容全部裁剪掉
    // 注意：裁剪必须放在绘制之前
    //    UIRectClip(CGRectMake(0, 0, 50, 50));
    UIImage *image = [UIImage imageNamed:@"小新.jpg"];
    // 默认绘制的内容尺寸跟图片尺寸一样大
    //    [image drawAtPoint:CGPointZero];
    //    [image drawInRect:rect];
    // 绘图
    [image drawAsPatternInRect:rect];
    [self drawText];
    [self attrText];
}


- (void)drawText
{
    // 绘制文字
    NSString *str = @"绘制文字普通文字绘制文字普通文字绘制文字普通文字";
    // 不会换行
    // [str drawAtPoint:CGPointZero withAttributes:nil];
    
    [str drawInRect:CGRectMake(100, 100, 200, 100) withAttributes:nil];
    
}
- (void)attrText
{
    // 绘制文字
    NSString *str = @"我是富文本文字我是富文本文字我是富文本文字";
    
    // 文字的起点
    // Attributes：文本属性
    NSMutableDictionary *textDict = [NSMutableDictionary dictionary];
    
    // 设置文字颜色
    textDict[NSForegroundColorAttributeName] = [UIColor redColor];
    
    // 设置文字字体
    textDict[NSFontAttributeName] = [UIFont systemFontOfSize:30];
    
    // 设置文字的空心颜色和宽度
    textDict[NSStrokeWidthAttributeName] = @3;
    textDict[NSStrokeColorAttributeName] = [UIColor yellowColor];
    
    // 创建阴影对象
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor greenColor];
    shadow.shadowOffset = CGSizeMake(4, 4);
    shadow.shadowBlurRadius = 3;
    textDict[NSShadowAttributeName] = shadow;
    
    // 富文本:给普通的文字添加颜色，字体大小
    [str drawAtPoint:CGPointZero withAttributes:textDict];
}


@end


