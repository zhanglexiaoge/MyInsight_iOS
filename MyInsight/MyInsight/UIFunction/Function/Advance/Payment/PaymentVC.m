
//
//  PaymentVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/7/8.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "PaymentVC.h"

@interface PaymentVC ()

@end

@implementation PaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"支付方式";
    
    // 支付模块
    
    /*
     银联支付
     
     微信支付
     
     支付宝支付
     
     */
    
    /**
     *  银联支付SDK：https://open.unionpay.com/ajweb/help/file
     *  需要调设的地方可以参考这里：http://www.jianshu.com/p/92d615f78509
     *  http://www.jianshu.com/p/92d615f78509
     */
    
    
    
    
    
    
    
    /**
     *  微信支付需要后台做大量的工作。
     *  SDK及官方Demo下载：https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=11_1
     *  官方的开发步骤参考这里：https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=8_5
     *  这篇文档说的也挺详细：http://wenku.baidu.com/link?url=II3oeAaiH9NXWqdoO5HwXWCGcEermreHGBAqKvYfyKz_JVQ2n4NlA56e0H1HJWTNFfUsrTAgjegHBeUpMRzN0S318qcVklep7VCq0wBkpv7
     *  还有这篇：http://www.cocoachina.com/bbs/read.php?tid=303132
     */
    
    
    
    /**
     *  支付宝
     *  官方接入流程、SDK下载请参考这里：http://doc.open.alipay.com/doc2/detail?treeId=59&articleId=103563&docType=1
     *  这篇博文说的也是很好，参考这里：http://www.jianshu.com/p/fe56e122663e
     */
    
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
