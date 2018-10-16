//
//  MQTTVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/2/28.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "MQTTVC.h"
#import <CommonCrypto/CommonHMAC.h>


#define MQTTHost @"127.0.0.1" // 设置服务器地址
#define MQTTPort 1883 // 设置服务器端口 默认:1883

@interface MQTTVC ()

//@property (nonatomic, strong) MQTTSession *session;

@property (nonatomic, strong) MQTTSessionManager *manager;
@property (strong, nonatomic) NSDictionary *mqttSettings;
@property (strong, nonatomic) NSString *rootTopic;
@property (strong, nonatomic) NSString *accessKey;
@property (strong, nonatomic) NSString *secretKey;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *clientId;
@property (nonatomic) NSInteger *qos;

@property (strong, nonatomic) NSMutableArray *chat;

@end

@implementation MQTTVC

/*
 [(iOS)MQTT连接 遗嘱 双向认证](https://www.jianshu.com/p/4676834ac3c4)
 [iOS MQTT----MQTTClient实战-看这篇的就够了](https://www.jianshu.com/p/80ea4507ca74)
 [Apollo-mqtt](https://github.com/ReReReReReRe/Apollo-mqtt)
 
 [开始使用 (Get Started)](http://emqtt.com/docs/v2/getstarted.html)
 [MQTT协议－MQTT协议解析（MQTT数据包结构）](https://www.cnblogs.com/zhangyu1024/p/6141818.html)
 [MQTT - iOS实现](https://blog.csdn.net/erice_e/article/details/79867031)
 
 
 [深入浅出－iOS的TCP/IP协议族剖析&&Socket](https://www.jianshu.com/p/cc756016243b)
 [深入浅出－网络七层模型&&网络数据包](https://www.jianshu.com/p/4b9d43c0571a)
 [iOS网络协议----HTTP/TCP/IP浅析](https://www.cnblogs.com/hyswa/p/4638974.html)
 [ping-pong操作](https://blog.csdn.net/sun19910114/article/details/52983553/)
 */

- (void)viewDidLoad {
  
    [super viewDidLoad];
    
    self.title = @"MQTT";
    
    // 创建一个传输对象
//    MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
//    // IP
//    transport.host = MQTTHost;
//    // 端口
//    transport.port = MQTTPort;
//    // 会话
//    self.session = [[MQTTSession alloc] init]; // 初始化
//    self.session.transport = transport;
//    self.session.delegate = self;
    
    
    [self aliyunMQTTSetUp];
    
}

//
- (void)aliyunMQTTSetUp {
    // MQTT iOS 接入示例
    // https://help.aliyun.com/document_detail/47755.html?spm=5176.doc42420.6.637.WOPRPQ
    
    self.mqttSettings = @{@"qos": @0,
                          @"groupId": @"GID_XXX",
                          @"secretKey": @"XXXXXXX",
                          @"accessKey": @"XXXXXX",
                          @"host": @"XXX.mqtt.aliyuncs.com",
                          @"port": @1883,
                          @"tls": @YES,
                          @"rootTopic": @"XXXX",
                          };
    
    self.rootTopic = self.mqttSettings[@"rootTopic"];
    self.accessKey = self.mqttSettings[@"accessKey"];
    self.secretKey = self.mqttSettings[@"secretKey"];
    self.groupId = self.mqttSettings[@"groupId"];
    self.qos = [self.mqttSettings[@"qos"] integerValue];
    //cientId的生成必须遵循GroupID@@@前缀，且需要保证全局唯一
    self.clientId=[NSString stringWithFormat:@"%@@@@%@",self.groupId,@"DEVICE_001"];
    
    
    if (!self.manager) {
        self.manager = [[MQTTSessionManager alloc] init];
        self.manager.delegate = self;
        self.manager.subscriptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:self.qos]
                                                                 forKey:[NSString stringWithFormat:@"%@/#", self.rootTopic]];
        //password的计算方式是，使用secretkey对groupId做hmac签名算法，具体实现参考macSignWithText方法
        NSString *passWord = [[self class] macSignWithText:self.groupId secretKey:self.secretKey];
        //此处从配置文件导入的Host即为MQTT的接入点，该接入点获取方式请参考资源申请章节文档，在控制台上申请MQTT实例，每个实例会分配一个接入点域名
        [self.manager connectTo:self.mqttSettings[@"host"]
                           port:[self.mqttSettings[@"port"] intValue]
                            tls:[self.mqttSettings[@"tls"] boolValue]
                      keepalive:60 //
                          clean:YES
                           auth:YES
                           user:self.accessKey
                           pass:passWord
                           will:NO
                      willTopic:NULL
                        willMsg:NULL
                        willQos:0
                 willRetainFlag:NO
                   withClientId:self.clientId
                 securityPolicy:NULL
                   certificates:NULL
                  protocolLevel:3 connectHandler:^(NSError *error) {
                      NSLog(@"错误信息");
                  }];
        
    } else {
        [self.manager connectToLast:^(NSError *error) {
            NSLog(@"错误信息");
        }];
    }
    
    // 添加监听状态观察者
    [self.manager addObserver:self
                   forKeyPath:@"state"
                      options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                      context:nil];
    
}

+ (NSString *)macSignWithText:(NSString *)text secretKey:(NSString *)secretKey
{
    NSData *saltData = [secretKey dataUsingEncoding:NSUTF8StringEncoding];
    NSData *paramData = [text dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* hash = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH ];
    CCHmac(kCCHmacAlgSHA1, saltData.bytes, saltData.length, paramData.bytes, paramData.length, hash.mutableBytes);
    NSString *base64Hash = [hash base64EncodedStringWithOptions:0];
    return base64Hash;
}

#pragma mark - 实现Session代理方法 处理数据
//- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
//    NSLog(@"LALALALALA: %@", data);
//}


// 监听当前连接状态
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    
    
    
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
