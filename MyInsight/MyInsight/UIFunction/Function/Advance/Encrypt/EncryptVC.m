//
//  EncryptVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/28.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "EncryptVC.h"
#import <Masonry.h>
#import "UIColor+Category.h"
#import "RSA.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h> // DES加密
#import <GTMBase64.h> // DES加密
#import "NSString+AES.h" // AES加密
#import "RSAUtil.h" // RSA加密
#import <AFNetworking.h>
#import "EncryptUtils.h"

//密钥
#define gkey            @"mobilewinx@easipass@1234"
//偏移量
#define gIv             @"01234567"

#define AES_KEY @"12345678"

// 公钥
#define RSA_Public_key         @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCxuWhp6EgQfrrSBtxlBwbU35lhjC67X0Y1KrhqolIfYo3/yWV1eryYVUhk5xeHsbKg9RHD9TpIZRUWIW5a8MrMBcgr1A/dgIHi2EM28drH4JRTmkTLVHReggFbb046k0ISpLW3XVW0jHB3/z3S1c/NT9V63SQK6WJ65/YP5xISNQIDAQAB"

// 私钥
#define RSA_Privite_key        @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALG5aGnoSBB+utIG3GUHBtTfmWGMLrtfRjUquGqiUh9ijf/JZXV6vJhVSGTnF4exsqD1EcP1OkhlFRYhblrwyswFyCvUD92AgeLYQzbx2sfglFOaRMtUdF6CAVtvTjqTQhKktbddVbSMcHf/PdLVz81P1XrdJArpYnrn9g/nEhI1AgMBAAECgYBEbsMAvLs69sFS6+djU1BTGYIC6Kp55ZawFDIMhVIf2aAZ1N+nW8pQ0c3dZIpP6qGAjrz3em6lv55d9iN7Cura/g57Rk4S3SRo5u4hWUd16NeIVP+HfreKIgZ6jwKQTfXt2KzDuIAHudvwT2UJBePgIIDQoKMEq4khtFiRGS1UgQJBAN/KpSOiRiGup8h/Iqespwfxyrqn5/4iyw1tpJCWzHddP7nJGpYmOL+ELWs/pReYclAOqH9ZIzOT2K8ZLt6yBOECQQDLTXZowK8wFgMudAE5TStC/zl3TAKMu/Gu5wlXSMoa+nwSy/FSIQZyypGeHR2X8QhbZ1Qz+uBCJm7gEGOWMWPVAkEAp5ajsFm3V0XqE/VRSGu88fAaN0nCK8h2cunm0Ph8ye6k6EY3iLW6zYD4WlZhFZhuEpHHkQZ5nAhdvlKHjPGXQQJAYOtF1rx9B/SGgb/F0ZZrWF4p/ChdUtBKcHIt7tGBoAjn22IkYl3iIBlYAEOrFwNOU5zX9IvWG1MNKn5Fq5VSHQJBAJG5xSY0IKzXWDsGnPIa9XlSTv1zl7RCGNDo7O1zh+5J/kjDpU9M2fIXEtzvGYHiOffz9FBh5ka69JJNFWoWAiw="

#define ENCRYPT_KEY     @"MfsKyo8IEMb"

#define RSA_Test_secret      @"lXOjdiMhPZjxDGF2eUzv7yD6zEFTLjyclrmPNTdMyEYCQC45d4ruo4QbV9jMN5lKfTxz3dxPIPaT06KxqU5CQVZqkX4Ttrw/anZencm4WnVUs96GIgpI3uY7ohOaG36Ak3cGvkQF6DvCO88MPrdS38DxUa2OSG4G5DVl4c74M4g="

// 加密的枚举值
/*
 MD5加密 DES加密 AES加密 RSA加密 RSA&JavaServer加密
 椭圆曲线数字签名算法(ECDSA)
 */
typedef NS_ENUM(NSUInteger, EncryptType) {
    EncryptTypeMD5 = 0,
    EncryptTypeDES,
    EncryptTypeAES,
    EncryptTypeRSA,
    EncryptTypeRSA_JAVA,
};

@interface EncryptVC ()

// 选择类型button
@property (nonatomic, strong) UILabel *typeLabel;
// 选择类型button
@property (nonatomic, strong) UIButton *typeButton;
// 原始数据标题
@property (nonatomic, strong) UILabel *originLabel;
// 原始数据
@property (nonatomic, strong) UITextField *originTextField;
// 加密标题
@property (nonatomic, strong) UILabel *encryptLabel;
// 加密内容输入
@property (nonatomic, strong) UITextView *encryptTextView;
// 解密标题
@property (nonatomic, strong) UILabel *decryptLabel;
// 解密内容输入
@property (nonatomic, strong) UITextView *decryptTextView;
// 加密button
@property (nonatomic, strong) UIButton *encryptButton;
// 解密button
@property (nonatomic, strong) UIButton *decryptButton;
// 解密类型 枚举值
@property (nonatomic, assign) EncryptType encryptType;

@end

@implementation EncryptVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"RSAEncrypt加密解密";
    
    [self creatContentView];
    
    //[self jiaMiJieMi];
    
    [self masonryLayout];
}

- (void)creatContentView {
    self.view.backgroundColor = [UIColor RandomColor];
    // 选择类型Label
    self.typeLabel = [[UILabel alloc] init];
    [self.view addSubview:self.typeLabel];
    self.typeLabel.backgroundColor = [UIColor RandomColor];
    self.typeLabel.text = @"选择加密解密类型";
    
    // 选择类型Button
    self.typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.typeButton];
    [self.typeButton setTitle:@"选择加密解密类型" forState:UIControlStateNormal];
    self.typeButton.backgroundColor = [UIColor RandomColor];
    [self.typeButton addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 原始数据Label
    self.originLabel = [[UILabel alloc] init];
    [self.view addSubview:self.originLabel];
    self.originLabel.backgroundColor = [UIColor RandomColor];
    self.originLabel.text = @"原始数据";
    
    //原始数据输入框
    self.originTextField = [[UITextField alloc] init];
    [self.view addSubview:self.originTextField];
    self.originTextField.backgroundColor = [UIColor RandomColor]; // 随机颜色
    self.originTextField.placeholder = @"请输入原始数据";
    
    // 生成加密数据Label
    self.encryptLabel = [[UILabel alloc] init];
    [self.view addSubview:self.encryptLabel];
    self.encryptLabel.backgroundColor = [UIColor RandomColor];
    self.encryptLabel.text = @"加密数据";
    
    // 生成加密数据TextView
    self.encryptTextView = [[UITextView alloc] init];
    [self.view addSubview:self.encryptTextView];
    self.encryptTextView.backgroundColor = [UIColor RandomColor];
    self.encryptTextView.editable = NO; // 不可编辑
    
    // 生成解密数据Label
    self.decryptLabel = [[UILabel alloc] init];
    [self.view addSubview:self.decryptLabel];
    self.decryptLabel.backgroundColor = [UIColor RandomColor];
    self.decryptLabel.text = @"解密数据";
    
    // 生成解密数据TextView
    self.decryptTextView = [[UITextView alloc] init];
    [self.view addSubview:self.decryptTextView];
    self.decryptTextView.backgroundColor = [UIColor RandomColor];
    self.decryptTextView.editable = NO; // 不可编辑
    
    // 生成加密数据Button
    self.encryptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.encryptButton];
    self.encryptButton.backgroundColor = [UIColor RandomColor];
    [self.encryptButton setTitle:@"生成密文" forState:UIControlStateNormal];
    [self.encryptButton addTarget:self action:@selector(encryptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 生成解密数据Button
    self.decryptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.decryptButton];
    self.decryptButton.backgroundColor = [UIColor RandomColor];
    [self.decryptButton setTitle:@"解密密文" forState:UIControlStateNormal];
    [self.decryptButton addTarget:self action:@selector(decryptButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Button的事件
- (void)typeButtonAction:(UIButton *)button {
    NSLog(@"选择类型方法");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择加密类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // MD5加密 DES加密 AES加密 RSA加密 RSA&JavaServer加密
//    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"BASE64加密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self.typeButton setTitle:@"BASE64加密" forState:UIControlStateNormal];
//        self.encryptType = EncryptTypeMD5;
//    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"MD5加密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.typeButton setTitle:@"MD5加密" forState:UIControlStateNormal];
        self.encryptType = EncryptTypeMD5;
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"DES加密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.typeButton setTitle:@"DES加密" forState:UIControlStateNormal];
        self.encryptType = EncryptTypeDES;
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"AES加密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.typeButton setTitle:@"AES加密" forState:UIControlStateNormal];
        self.encryptType = EncryptTypeAES;
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"RSA加密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.typeButton setTitle:@"RSA加密" forState:UIControlStateNormal];
        self.encryptType = EncryptTypeRSA;
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"RSA&JavaServer加密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.typeButton setTitle:@"RSA&JavaServer加密" forState:UIControlStateNormal];
        self.encryptType = EncryptTypeRSA_JAVA;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    //[alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [alertController addAction:action4];
    [alertController addAction:action5];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}

// 加密
- (void)encryptButtonAction:(UIButton *)button {
    NSLog(@"加密button动作方法");
    if (self.encryptType == 0) {
        self.encryptType = EncryptTypeMD5; // 默认
        [self.typeButton setTitle:@"MD5加密" forState:UIControlStateNormal];
    }
    
    switch (self.encryptType) {
        case EncryptTypeMD5:
            NSLog(@"生成密文 MD5");
            [self md5Encrypt];
            break;
        case EncryptTypeDES:
            NSLog(@"生成密文 DES");
            [self desEncrypt];
            break;
        case EncryptTypeAES:
            NSLog(@"生成密文 AES");
            [self aesEncrypt];
            break;
        case EncryptTypeRSA:
            NSLog(@"生成密文 RSA");
            [self rsaEncrypt];
            break;
        case EncryptTypeRSA_JAVA:
            NSLog(@"生成密文 RSA_JAVA");
            [self rsaJavaEncrypt];
            break;
        default:
            break;
    }
    
    NSLog(@"原始数据：%@", self.originTextField.text);
}

// 解密
- (void)decryptButtonAction:(UIButton *)button {
    NSLog(@"解密button动作方法");
    if (self.encryptType == 0) {
        self.encryptType = EncryptTypeMD5; // 默认
        [self.typeButton setTitle:@"MD5加密" forState:UIControlStateNormal];
    }
    
    switch (self.encryptType) {
        case EncryptTypeMD5:
            NSLog(@"解密密文 MD5");
            [self md5Decrypt];
            break;
        case EncryptTypeDES:
            NSLog(@"解密密文 DES");
            [self desDecrypt];
            break;
        case EncryptTypeAES:
            NSLog(@"解密密文 AES");
            [self aesDecrypt];
            break;
        case EncryptTypeRSA:
            NSLog(@"解密密文 RSA");
            [self rsaDecryPt];
            break;
        case EncryptTypeRSA_JAVA:
            NSLog(@"解密密文 RSA_JAVA");
            [self rsaJavaDecrypt];
            break;
        default:
            break;
    }
    
    NSLog(@"原始数据：%@", self.originTextField.text);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES]; // 回收键盘
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"点击结束啊");
}

/**************         MD5方法        ***************/
/*
 [MD5不是加密](https://juejin.im/entry/5807294f67f3560058dad715)
 [iOS MD5和 base64加密](https://www.jianshu.com/p/a2d0ebbbb754)
 [iOS MD5加密](https://www.jianshu.com/p/02a2946d4e97)
 [iOS中使用MD5加密](https://www.jianshu.com/p/bb04989a0998)
 */
#pragma mark - MD5加密 加密后显示在view上
- (void)md5Encrypt {
    // 回收键盘
    [self.view endEditing:YES];
    self.encryptTextView.text = [NSString stringWithFormat:
                                 @"原始数据：%@ \nMD5加密32位小写：%@ \nMD5加密32位大写：%@ \nMD5加密16位小写：%@ \nMD5加密16位大写：%@",
                                 self.originTextField.text,
                                 [self MD5ForLower32Bate:self.originTextField.text],
                                 [self MD5ForUpper32Bate:self.originTextField.text],
                                 [self MD5ForLower16Bate:self.originTextField.text],
                                 [self MD5ForUpper16Bate:self.originTextField.text]];
}
#pragma mark - MD5解密 MD5加密是不可逆
- (void)md5Decrypt {
    self.decryptTextView.text = @"MD5从严格意义上讲不属于加密算法，因为它没有解密过程，MD5有两个最主要的特征：1.加密的不可逆性，只能加密，不能解密；2.任意长度的明文经过加密之后得到长度都是固定的，长度为16进制32位。";
}
#pragma mark - 32位 小写
- (NSString *)MD5ForLower32Bate:(NSString *)str {
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    return digest;
}
#pragma mark - 32位 大写
- (NSString *)MD5ForUpper32Bate:(NSString *)str {
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02X", result[i]];
    }
    
    return digest;
}
#pragma mark - 16位 大写
- (NSString *)MD5ForUpper16Bate:(NSString *)str {
    
    NSString *md5Str = [self MD5ForUpper32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}
#pragma mark - 16位 小写
- (NSString *)MD5ForLower16Bate:(NSString *)str {
    
    NSString *md5Str = [self MD5ForLower32Bate:str];
    
    NSString  *string;
    for (int i=0; i<24; i++) {
        string=[md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return string;
}

/************     DES 加密      ************/
/*
 [iOS开发中如何使用DES加密](https://www.jianshu.com/p/4d3545674a50)
 [iOS开发－DES加密解密算法。](https://www.jianshu.com/p/d5f932967818)
 [iOS之DES加密](https://www.jianshu.com/p/e5df70409c73)
 */
#pragma mark - DES 加密
- (void)desEncrypt {
    self.encryptTextView.text = [self encrypt:self.originTextField.text];
}

- (void)desDecrypt {
    self.decryptTextView.text = [self decrypt:self.encryptTextView.text];
}

- (NSString*)encrypt:(NSString*)plainText {
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

- (NSString*)decrypt:(NSString*)encryptText {
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) [gkey UTF8String];
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark - AES加密
/*
 [iOS开发之AES+Base64数据混合加密与解密](http://ios.jobbole.com/84483/)
 [iOS AES的加密解密](https://blog.csdn.net/quanqinyang/article/details/40111309)
 [【安全篇】iOS中使用AES 256对称加密](https://blog.methodname.com/ioszhong-shi-yong-aes-256dui-cheng-jia-mi/)
 [iOS开发之Objective-c的AES加密和解密算法的实现](https://www.lidaren.com/archives/1470)
 [iOS开发探索-AES加解密](https://www.jianshu.com/p/3f524fcd3aaf)
 [iOS CommonCrypto 对称加密 AES ecb,cbc](https://www.cnblogs.com/cocoajin/p/6150203.html)
 */
- (void)aesEncrypt {
    NSLog(@"AES加密");
    //self.encryptTextView.text = [self.originTextField.text AES256_Encrypt:AES_KEY];
    self.encryptTextView.text = [[[self.originTextField.text dataUsingEncoding:NSUTF8StringEncoding] AES256_Encrypt:AES_KEY] newStringInBase64FromData];
}

- (void)aesDecrypt {
    NSLog(@"AES解密");
    //self.decryptTextView.text = [self.encryptTextView.text AES256_Decrypt:AES_KEY];
    self.decryptTextView.text = [[NSString alloc] initWithData:[[[self.originTextField.text dataUsingEncoding:NSUTF8StringEncoding] AES256_Encrypt:AES_KEY] AES256_Decrypt:AES_KEY] encoding:NSUTF8StringEncoding];
}

#pragma mark - RSA加密
/*
 好像这RSA两个文件他么的一样的
 */
// 公钥加密数据
- (void)rsaEncrypt {
    NSLog(@"RSA加密");
    // 生成一个随机的8位字符串，作为des加密数据的key,对数据进行des加密，对加密后的数据用公钥再进行一次rsa加密
    self.encryptTextView.text = [RSAUtil encryptString:self.originTextField.text publicKey:RSA_Public_key];
}

// 私钥解密数据
- (void)rsaDecryPt {
    NSLog(@"RSA解密");
    self.decryptTextView.text = [RSAUtil decryptString:self.encryptTextView.text privateKey:RSA_Privite_key];
}

#pragma mark - RSA JAVA加密
- (void)rsaJavaEncrypt {
    NSLog(@"RSA JAVA加密");
    self.encryptTextView.text = [RSAUtil encryptString:self.originTextField.text publicKey:RSA_Public_key];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer =[AFJSONResponseSerializer serializer];
    
    NSString * timeStamp = [EncryptUtils getSysTimeStamp];
    NSString * originKey = [NSString stringWithFormat:@"%@%@", timeStamp, ENCRYPT_KEY];
    NSString * encryptKey = [EncryptUtils md5:originKey];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:timeStamp,@"time", encryptKey, @"md5", self.encryptTextView.text, @"content", self.encryptTextView.text, @"ciphertext", nil];
    [manager POST:@"http://192.168.1.127:8080/DesAndRsaDemo/rsa/testRsa.do" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"123");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)rsaJavaDecrypt {
    NSLog(@"RSA JAVA解密");
    self.decryptTextView.text = [RSAUtil decryptString:RSA_Test_secret publicKey:RSA_Public_key];
    
}

#pragma mark - 代码约束布局
- (void)masonryLayout {
    // 选择类型Label
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10.0f+64.0f);
        make.left.equalTo(self.view.mas_left).offset(20.0f);
        make.width.offset(150.0f);
        make.height.offset(40.0f);
    }];
    // 选择加密解密的类型
    [self.typeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(10.0f+64.0f);
        make.left.equalTo(self.typeLabel.mas_right).offset(20.0f);
        make.right.equalTo(self.view.mas_right).offset(-20.0f);
        make.height.offset(40.0f);
    }];
    // 原始数据Label
    [self.originLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(10.0f);
        make.left.equalTo(self.view.mas_left).offset(20.0f);
        make.width.offset(150.0f);
        make.height.offset(40.0f);
    }];
    // 原始数据输入框
    [self.originTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originLabel.mas_bottom).offset(10.0f);
        make.left.equalTo(self.view.mas_left).offset(20.0f);
        make.right.equalTo(self.view.mas_right).offset(-20.0f);
        make.height.offset(40.0f);
    }];
    // 生成加密数据Label
    [self.encryptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.originTextField.mas_bottom).offset(10.0f);
        make.left.equalTo(self.view.mas_left).offset(20.0f);
        make.right.equalTo(self.view.mas_right).offset(-20.0f);
        make.height.offset(40.0f);
    }];
    // 生成加密内容
    [self.encryptTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.encryptLabel.mas_bottom).offset(10.0f);
        make.left.equalTo(self.view.mas_left).offset(20.0f);
        make.right.equalTo(self.view.mas_right).offset(-20.0f);
    }];
    // 生成解密数据Label
    [self.decryptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.encryptTextView.mas_bottom).offset(10.0f);
        make.left.equalTo(self.view.mas_left).offset(20.0f);
        make.right.equalTo(self.view.mas_right).offset(-20.0f);
        make.height.offset(40.0f);
    }];
    // 生成解密内容
    [self.decryptTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decryptLabel.mas_bottom).offset(10.0f);
        make.left.equalTo(self.view.mas_left).offset(20.0f);
        make.right.equalTo(self.view.mas_right).offset(-20.0f);
        make.height.equalTo(self.encryptTextView.mas_height).multipliedBy(1.0f);
    }];
    // 点击进行加密
    [self.encryptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.decryptTextView.mas_bottom).offset(10.0f);
        make.left.equalTo(self.view.mas_left).offset(20.0f);
        make.height.offset(40.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20.0f);
    }];
    // 点击进行解密
    [self.decryptButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.encryptButton.mas_top).offset(0.0f);
        make.left.equalTo(self.encryptButton.mas_right).offset(20.0f);
        make.right.equalTo(self.view.mas_right).offset(-20.0f);
        make.bottom.equalTo(self.encryptButton.mas_bottom).offset(0.0f);
        make.width.equalTo(self.encryptButton.mas_width).multipliedBy(1.0f);
    }];
}

#pragma mark - 加密解密
- (void)jiaMiJieMi {
    // 教程
    // https://www.jianshu.com/p/eaaf93a6cc9c
    // iOS开发探索-RSA加解密
    NSString *pubkey = @"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI2bvVLVYrb4B0raZgFP60VXY\ncvRmk9q56QiTmEm9HXlSPq1zyhyPQHGti5FokYJMzNcKm0bwL1q6ioJuD4EFI56D\na+70XdRz1CjQPQE3yXrXXVvOsmq9LsdxTFWsVBTehdCmrapKZVVx6PKl7myh0cfX\nQmyveT/eqyZK1gYjvQIDAQAB\n-----END PUBLIC KEY-----";
    NSString *privkey = @"-----BEGIN PRIVATE KEY-----\nMIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMMjZu9UtVitvgHS\ntpmAU/rRVdhy9GaT2rnpCJOYSb0deVI+rXPKHI9Aca2LkWiRgkzM1wqbRvAvWrqK\ngm4PgQUjnoNr7vRd1HPUKNA9ATfJetddW86yar0ux3FMVaxUFN6F0KatqkplVXHo\n8qXubKHRx9dCbK95P96rJkrWBiO9AgMBAAECgYBO1UKEdYg9pxMX0XSLVtiWf3Na\n2jX6Ksk2Sfp5BhDkIcAdhcy09nXLOZGzNqsrv30QYcCOPGTQK5FPwx0mMYVBRAdo\nOLYp7NzxW/File//169O3ZFpkZ7MF0I2oQcNGTpMCUpaY6xMmxqN22INgi8SHp3w\nVU+2bRMLDXEc/MOmAQJBAP+Sv6JdkrY+7WGuQN5O5PjsB15lOGcr4vcfz4vAQ/uy\nEGYZh6IO2Eu0lW6sw2x6uRg0c6hMiFEJcO89qlH/B10CQQDDdtGrzXWVG457vA27\nkpduDpM6BQWTX6wYV9zRlcYYMFHwAQkE0BTvIYde2il6DKGyzokgI6zQyhgtRJ1x\nL6fhAkB9NvvW4/uWeLw7CHHVuVersZBmqjb5LWJU62v3L2rfbT1lmIqAVr+YT9CK\n2fAhPPtkpYYo5d4/vd1sCY1iAQ4tAkEAm2yPrJzjMn2G/ry57rzRzKGqUChOFrGs\nlm7HF6CQtAs4HC+2jC0peDyg97th37rLmPLB9txnPl50ewpkZuwOAQJBAM/eJnFw\nF5QAcL4CYDbfBKocx82VX/pFXng50T7FODiWbbL4UnxICE0UBFInNNiWJxNEb6jL\n5xd0pcy9O2DOeso=\n-----END PRIVATE KEY-----";
    
    NSString *originString = @"hello world!";
    NSString *encWithPubKey;
    NSString *decWithPrivKey;
    NSString *encWithPrivKey;
    NSString *decWithPublicKey;
    
    // Demo: encrypt with public key
    encWithPubKey = [RSA encryptString:originString publicKey:pubkey];
    NSLog(@"Enctypted with public key: %@", encWithPubKey);
    // Demo: decrypt with private key
    decWithPrivKey = [RSA decryptString:encWithPubKey privateKey:privkey];
    NSLog(@"Decrypted with private key: %@", decWithPrivKey);
    
    // Demo: encrypt with public key
    encWithPubKey = [RSA encryptString:originString publicKey:pubkey];
    NSLog(@"Enctypted with public key: %@", encWithPubKey);
    // Demo: decrypt with private key
    decWithPrivKey = [RSA decryptString:encWithPubKey privateKey:privkey];
    NSLog(@"Decrypted with private key: %@", decWithPrivKey);
    
    
    // by PHP
    encWithPubKey = @"CKiZsP8wfKlELNfWNC2G4iLv0RtwmGeHgzHec6aor4HnuOMcYVkxRovNj2r0Iu3ybPxKwiH2EswgBWsi65FOzQJa01uDVcJImU5vLrx1ihJ/PADUVxAMFjVzA3+Clbr2fwyJXW6dbbbymupYpkxRSfF5Gq9KyT+tsAhiSNfU6akgNGh4DENoA2AoKoWhpMEawyIubBSsTdFXtsHK0Ze0Cyde7oI2oh8ePOVHRuce6xYELYzmZY5yhSUoEb4+/44fbVouOCTl66ppUgnR5KjmIvBVEJLBq0SgoZfrGiA3cB08q4hb5EJRW72yPPQNqJxcQTPs8SxXa9js8ZryeSxyrw==";
    decWithPrivKey = [RSA decryptString:encWithPubKey privateKey:privkey];
    NSLog(@"(PHP enc)Decrypted with private key: %@", decWithPrivKey);
    
    // Demo: encrypt with private key
    // TODO: encryption with private key currently NOT WORKING YET!
    //encWithPrivKey = [RSA encryptString:originString privateKey:privkey];
    //NSLog(@"Enctypted with private key: %@", encWithPrivKey);
    
    // Demo: decrypt with public key
    encWithPrivKey = @"aQkSJwaYppc2dOGEOtgPnzLYX1+1apwqJga2Z0k0cVCo7vCqOY58PyVuhp49Z+jHyIEmIyRLsU9WOWYNtPLg8XDnt1WLSst5VNyDlJJehbvm7gbXewxrPrG+ukZgo11GYJyU42DqNr59D3pQak7P2Ho6zFvN0XJ+lnVXJ1NTmgQFQYeFksTZFmJmQ5peHxpJy5XBvqjfYOEdlkeiiPKTnTQaQWKJfC9CRtWfTTYM2VKMBSTB0eNWto5XAu5BvgEgTXzndHGzsWW7pOHLqxVagr0xhNPPCB2DRE5PClE2FD9qNv0JcSMnUJ8bLvk6Yeh7mMDObJ4kBif5G9VnHjTqTg==";
    decWithPublicKey = [RSA decryptString:encWithPrivKey publicKey:pubkey];
    NSLog(@"(PHP enc)Decrypted with public key: %@", decWithPublicKey);
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
