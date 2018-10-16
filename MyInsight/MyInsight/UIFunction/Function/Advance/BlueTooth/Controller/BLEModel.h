//
//  BLEModel.h
//  MyInsight
//
//  Created by SongMengLong on 2018/7/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

//蓝牙连接状态的定义
#define kCONNECTED_UNKNOWN_STATE @"未知蓝牙状态"
#define kCONNECTED_RESET         @"蓝牙重置"
#define kCONNECTED_UNSUPPORTED   @"该设备不支持蓝牙"
#define kCONNECTED_UNAUTHORIZED  @"未授权蓝牙权限"
#define kCONNECTED_POWERED_OFF   @"蓝牙已关闭"
#define kCONNECTED_POWERD_ON     @"蓝牙已打开"
#define kCONNECTED_ERROR         @"未知的蓝牙错误"

/**
 设备名称
 */
#define PMServiceName @"Bozonn-Air01"
/**
 设备UUID
 */
#define PMServiceUUID @"FFE0"
/**
 设备配置UUID
 */
#define PMServiceUUID_Config @"00002902-0000-1000-8000-00805f9b34fb"
/**
 设备读取UUID
 */
#define PMServiceUUID_Receive @"0000ffe1-0000-1000-8000-00805f9b34fb"
/**
 设备写入UUID
 */
#define PMServiceUUID_Send @"0000ffe1-0000-1000-8000-00805f9b34fb"


/**
 蓝牙链接状态
 
 @param state 状态
 */
typedef void (^BLELinkBlock)(NSString *state);

/**
 蓝牙返回数据
 
 @param array 返回数据
 */
typedef void (^BLEDataBlock)(NSMutableArray *array);

typedef enum BLEState_NOW{
    
    BLEState_Successful = 0,//连接成功
    BLEState_Disconnect = 1, // 失败
    BLEState_Normal,         // 未知
    
}BLEState_NOW;


/**
 蓝牙连接成功 或者断开
 
 */
typedef void(^BLEStateBlcok)(int number);


@interface BLEModel : NSObject


@property (nonatomic,copy) NSString *connectState;//蓝牙连接状态
@property (nonatomic,copy) BLELinkBlock linkBlcok;
@property (nonatomic,copy) BLEDataBlock dataBlock;
@property (nonatomic,copy) BLEStateBlcok stateBlock;


/**
 *  开始扫描
 */
-(void)startScan;

/**
 主动断开链接
 */
-(void)cancelPeripheralConnection;

/**
 发送命令
 */
- (void) sendData:(NSData *)data;



@end
