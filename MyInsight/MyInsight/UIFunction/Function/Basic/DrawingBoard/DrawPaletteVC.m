//
//  DrawPaletteVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/6/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "DrawPaletteVC.h"

@interface DrawPaletteVC ()

//展示颜色的View
@property (weak, nonatomic) IBOutlet UIView *showColorView;

@property (weak, nonatomic) IBOutlet UIToolbar *toolBarView;

/** 线宽 */
@property (nonatomic,assign)CGFloat stroke_size;
@property (weak, nonatomic) IBOutlet UILabel *show_size;


@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;

@end

@implementation DrawPaletteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

#pragma mark -  初始化方法
-(void)setup{
    self.redSlider.value = [self.model.red floatValue];
    self.greenSlider.value = [self.model.green floatValue];
    self.blueSlider.value = [self.model.blue floatValue];
    self.sizeSlider.value = [self.model.size floatValue];
    self.show_size.text =[NSString stringWithFormat:@"%d",(int)self.sizeSlider.value];
    self.showColorView.backgroundColor = [[UIColor alloc] initWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
    self.toolBarView.backgroundColor = [[UIColor alloc] initWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
}


#pragma mark - 控件监听的事件

//RGB的Slider监听获取对应的slider.value
- (IBAction)slider:(UISlider *)sender {
    if (sender.tag == 1) {
        self.redSlider.value = sender.value;
        
    }else if (sender.tag == 2){
        self.greenSlider.value = sender.value;
        
    }else if (sender.tag == 3){
        self.blueSlider.value = sender.value;
        
    }
    //设置showColorView和toolBaoView显示的颜色
    self.showColorView.backgroundColor = [[UIColor alloc] initWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
    self.toolBarView.backgroundColor = [[UIColor alloc] initWithRed:self.redSlider.value green:self.greenSlider.value blue:self.blueSlider.value alpha:1];
    [self.model setRed:@(self.redSlider.value) green:@(self.greenSlider.value) blue:@(self.blueSlider.value)];
}
//设置画笔的粗细
- (IBAction)sizeSlider:(UISlider *)sender {
    self.show_size.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    self.model.size = @((int)sender.value);
}
//设置完毕，要退出当前Modal
- (IBAction)doneClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
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
