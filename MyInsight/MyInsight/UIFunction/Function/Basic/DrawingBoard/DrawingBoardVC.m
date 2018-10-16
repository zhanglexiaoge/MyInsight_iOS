//
//  DrawingBoardVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/6/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "DrawingBoardVC.h"
#import "DrawPaletteVC.h"
#import "CancasView.h"

@interface DrawingBoardVC ()
// 设置画板页面
@property (nonatomic, strong) DrawPaletteVC *drawPaletteVC;
// 绘图板
@property (weak, nonatomic) IBOutlet CancasView *canvasView;

@end

@implementation DrawingBoardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绘图板";
    
    // 设置页面
    
    
    
    
}

#pragma mark - 保存到沙盒本地
- (IBAction)saveToLocalButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"保存到沙盒本地");
    // 暂无此功能
}

#pragma mark - 打开文件
- (IBAction)openFileButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"打开文件");
    // 暂无此功能
}

#pragma mark - 存储到相册中
- (IBAction)saveButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"存储到相册中");
    //把画板上的内容生成一张图片,保存到系统相册当中.
    UIGraphicsBeginImageContextWithOptions(self.canvasView.bounds.size, NO, 0);
    //把画板的内容渲染到上下文当中.
    //获取当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.canvasView.layer renderInContext:ctx];
    //从上下文当中生成一张图片
    UIImage *newImage =  UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    //把生成的图片写入到系统相册
    //注意:保存完毕执行的这方法必须得要是
    //- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    NSLog(@"%s",__func__);
}

#pragma mark - 删除当前画板
- (IBAction)deleteButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"删除当前画板");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"要删除当前绘画板么？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //动画操作，然后删除操作
        [self changeUIView1];
        [self.canvasView clear];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

/** 转场动画 */
- (void)changeUIView1 {
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:1.0f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.canvasView cache:YES];
    [self.canvasView exchangeSubviewAtIndex:1 withSubviewAtIndex:0  ];
    [UIView commitAnimations];
}

#pragma mark - 使用橡皮擦
- (IBAction)rubberButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"使用橡皮擦");
    self.canvasView.rubber = ![self.canvasView isRubber];
}

#pragma mark - 全撤销
- (IBAction)replayAllButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"全撤销");
    NSInteger n = self.canvasView.array.count;
    for (int i = 0; i< n; i++) {
        [self replayFounction];
    }
    [self.canvasView setNeedsDisplay];
}

-(void)replayFounction{
    if (self.canvasView.array.count>=1) {
        [self.canvasView.replayArray addObject:[self.canvasView.array lastObject]];;
        [self.canvasView.array removeLastObject];
    }
}

#pragma mark - 撤销
- (IBAction)replayButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"撤销");
    [self replayFounction];
    [self.canvasView setNeedsDisplay];
}

#pragma mark - 向前
- (IBAction)forwardButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"向前");
    [self forwardFounction];
    [self.canvasView setNeedsDisplay];
}

-(void)forwardFounction{
    if (self.canvasView.replayArray.count>=1) {
        [self.canvasView.array addObject:[self.canvasView.replayArray lastObject]];
        [self.canvasView.replayArray removeLastObject];
    }
}

#pragma mark - 进入设置画笔页面
- (IBAction)paletteButtonAction:(UIBarButtonItem *)sender {
    NSLog(@"设置画笔");
    
    self.drawPaletteVC = [[UIStoryboard storyboardWithName:@"Home" bundle:NULL] instantiateViewControllerWithIdentifier:@"DrawPaletteVC"];
    self.drawPaletteVC.model = self.canvasView.model;
    
    [self presentViewController:self.drawPaletteVC animated:YES completion:nil];
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
