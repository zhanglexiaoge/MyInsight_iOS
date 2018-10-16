


//
//  QRCodeVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/19.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "QRCodeVC.h"
#import <HMScannerController.h>
#import <Masonry.h>

@interface QRCodeVC ()
// 二维码
@property (nonatomic, strong) UIImageView *qrcodeImgView;
// 生成二维码的字符串
@property (nonatomic, strong) UITextField *inputTextField;
// 扫描二维码
@property (nonatomic, strong) UIButton *scanButton;
// 生成二维码
@property (nonatomic, strong) UIButton *createButton;

@end

@implementation QRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码";
    
    [self creatUI];
    
    [self masonryLayout];
}

#pragma mark - 绘制UI
- (void)creatUI {
    // 生成二维码
    self.qrcodeImgView = [[UIImageView alloc] init];
    [self.view addSubview:self.qrcodeImgView];
    self.qrcodeImgView.backgroundColor = [UIColor yellowColor];
    //输入框
    self.inputTextField = [[UITextField alloc] init];
    [self.view addSubview:self.inputTextField];
    self.inputTextField.backgroundColor = [UIColor orangeColor];
    self.inputTextField.placeholder = @"Input Text";
    // 创建button
    self.createButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.createButton];
    self.createButton.backgroundColor = [UIColor magentaColor];
    [self.createButton setTitle:@"CREATE" forState:UIControlStateNormal];
    [self.createButton addTarget:self action:@selector(createButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 扫描button
    self.scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.scanButton];
    self.scanButton.backgroundColor = [UIColor brownColor];
    [self.scanButton setTitle:@"SCAN" forState:UIControlStateNormal];
    [self.scanButton addTarget:self action:@selector(scanButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark 生成button动作方法
- (void)createButtonAction:(UIButton *)button {
    NSLog(@"输入框的字符串：%@", self.inputTextField.text);
    // 二维码字符串
    NSString *qrcodeString;
    
    if (self.inputTextField.text.length == 0 || self.inputTextField.text == NULL) {
        qrcodeString = @"滚滚长江东逝水，浪花淘尽英雄。是非成败转头空，青山依旧在，几度夕阳红。安稳锦衾今夜梦，月明好渡江湖，相思休问定何如，明知春去后，管得落花无。";
    } else {
        qrcodeString = self.inputTextField.text;
    }
    // 生成二维码
    [HMScannerController cardImageWithCardName:qrcodeString avatar:nil scale:1.0 completion:^(UIImage *image) {
        self.qrcodeImgView.image = image;
    }];
}

#pragma mark - 扫描button动作方法
- (void)scanButtonAction:(UIButton *)button {
    // 打开扫描二维码 返回字符串
    HMScannerController *scanner = [HMScannerController scannerWithCardName:@"https://www.github.com/njhu" avatar:nil completion:^(NSString *stringValue) {
        NSLog(@"返回二维码字符串： %@", stringValue);
    }];
    // 设置颜色
    [scanner setTitleColor:[UIColor redColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
}

#pragma mark - 代码约束布局
- (void)masonryLayout {
    [self.qrcodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100.0f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5f);
        make.height.equalTo(self.qrcodeImgView.mas_width).multipliedBy(1.0f);
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(1.0f);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.qrcodeImgView.mas_bottom).offset(30.0f);
        make.left.equalTo(self.view.mas_left).offset(40.0f);
        make.right.equalTo(self.view.mas_right).offset(-40.0f);
        make.height.offset(40.0f);
    }];
    
    [self.createButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputTextField.mas_bottom).offset(30.0f);
        make.left.equalTo(self.view.mas_left).offset(40.0f);
        make.right.equalTo(self.view.mas_right).offset(-40.0f);
        make.height.offset(40.0f);
    }];
    
    [self.scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.createButton.mas_bottom).offset(30.0f);
        make.left.equalTo(self.view.mas_left).offset(40.0f);
        make.right.equalTo(self.view.mas_right).offset(-40.0f);
        make.height.offset(40.0f);
    }];
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
