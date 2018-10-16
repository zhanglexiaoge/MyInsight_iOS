//
//  LiftCycleVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/25.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "LiftCycleVC.h"
#import <Masonry.h>
#import "Header.h"
#import "UIColor+Category.h"

@interface LiftCycleVC ()
// 输出页面
@property (weak, nonatomic) UITextView *inputTextView;

@end

@implementation LiftCycleVC

- (void)loadView {
    [super loadView];
    
    [self life:__FUNCTION__];
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"生命周期";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self life:__FUNCTION__];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self life:__FUNCTION__];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self life:__FUNCTION__];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self life:__FUNCTION__];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self life:__FUNCTION__];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self life:__FUNCTION__];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self life:__FUNCTION__];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self life:__FUNCTION__];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self life:__FUNCTION__];
}

// 打印输出函数
- (void)life:(const char *)func {
    
    NSLog(@"%s", __FUNCTION__);
    
    NSMutableString *strM = [NSMutableString stringWithFormat:@"%@", self.inputTextView.text ?: @""];
    
    [strM appendString:[NSString stringWithUTF8String:func]];
    
    self.inputTextView.text = [strM.copy stringByAppendingString:@"\n"];
}

// inputTextView的getter方法
- (UITextView *)inputTextView {
    
    if (_inputTextView == nil) {
        UITextView *textView = [[UITextView alloc] init];
        [self.view addSubview:textView];
        // 代码约束布局
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        textView.backgroundColor = [UIColor RandomColor]; // 随机颜色
        textView.textColor = [UIColor RandomColor]; // 随机颜色
        textView.font = AdaptedFontSize(16);
        
        _inputTextView = textView;
    }
    
    return _inputTextView;
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
