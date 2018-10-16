//
//  MQTTVC.h
//  MyInsight
//
//  Created by SongMenglong on 2018/2/28.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

//#import <MQTTClient/MQTTClient.h>
#import <MQTTClient/MQTTSessionManager.h>

@interface MQTTVC : BaseVC<MQTTSessionManagerDelegate>

@end
