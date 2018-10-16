//
//  HistogramVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "HistogramVC.h"
#import "UIColor+Category.h"

@interface HistogramVC ()

@end

@implementation HistogramVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"柱状图";
    
    [self redView];
    
    //[self.view makeToast:@"点击图案!" duration:3 position:CSToastPositionCenter];
    
}

- (Class)drawViewClass {
    return [HistogramView class];
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

@implementation HistogramView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    NSArray *arr = [self arrRandom];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = 0;
    CGFloat h = 0;
    
    for (int i = 0; i < arr.count; i++) {
        w = rect.size.width / (2 * arr.count - 1);
        x = 2 * w * i;
        h = [arr[i] floatValue] / 100.0 * rect.size.height;
        y = rect.size.height - h;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(x, y, w, h)];
        [[UIColor RandomColor] set];
        [path fill];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setNeedsDisplay];
}

- (NSArray *)arrRandom {
    int totoal = 100;
    NSMutableArray *arrM = [NSMutableArray array];
    
    int temp = 0; // 30 40 30
    for (int i = 0; i < arc4random_uniform(10) + 1; i++) {
        temp = arc4random_uniform(totoal) + 1;
        // 100 1~100
        // 随机出来的临时值等于总值，直接退出循环，因为已经把总数分配完毕，没必要在分配。
        [arrM addObject:@(temp)];
        // 解决方式：当随机出来的数等于总数直接退出循环。
        if (temp == totoal) {
            break;
        }
        totoal -= temp;
    }
    // 100 30 1~100
    // 70 40 0 ~ 69 1 ~ 70
    // 30 25
    // 5
    if (totoal) {
        [arrM addObject:@(totoal)];
    }
    return arrM;
}
@end

