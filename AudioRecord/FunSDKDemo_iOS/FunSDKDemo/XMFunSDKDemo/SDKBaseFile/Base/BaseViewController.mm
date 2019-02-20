//
//  BaseViewController.m
//  XMeye_Old
//
//  Created by zyj on 15/1/7.
//  Copyright (c) 2015年 hzjf. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"
#import "FunSDK/FunSDK.h"

class CBaseObjInfo
{

public:
    CBaseObjInfo()
    {
        _pWnd = 0;
        _hWnd = 0;
    };

    virtual ~CBaseObjInfo()
    {
        FUN_UnRegWnd(_hWnd);
        _hWnd = 0;
    };
    
    void Init(void *pWnd)
    {
        _pWnd = pWnd;
        _hWnd = FUN_RegWnd(pWnd);
    };
    
    UI_HANDLE GetId()
    {
        return _hWnd;
    }
private:
    UI_HANDLE _hWnd;
    void *_pWnd;
};

@interface BaseViewController ()
{
    CBaseObjInfo _info;
}
@end

@implementation BaseViewController

- (BOOL)shouldAutorotate {
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActives) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegrounds) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(void)applicationWillResignActives {
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

-(void)applicationWillEnterForegrounds
{
}

-(int)MsgHandle {
    if (_info.GetId() == 0) {
        _info.Init((__bridge void *)self);
    }
    return _info.GetId();
}

-(void)CloseMsgHandle {
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)dismis
{
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }else{
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

