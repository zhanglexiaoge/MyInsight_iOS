//
//  ViewController.m
//  SDKTest
//
//  Created by gemvary_mini_2 on 2018/11/19.
//  Copyright © 2018 happylong. All rights reserved.
//

#import "ViewController.h"
#import <MLSDK/MLSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}



- (IBAction)clickedAction:(UIButton *)sender {
    
    UIViewController *buttonVC = [MLAction creatFirstVC];
    [self.navigationController pushViewController:buttonVC animated:YES];
    
}



@end
