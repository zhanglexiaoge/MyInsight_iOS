//
//  FileSharedVC.h
//  MyInsight
//
//  Created by SongMenglong on 2018/5/15.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

//setep0:在应用程序的Info.plist文件中添加UIFileSharingEnabled键，并将键值设置为YES

//step1. 导入QuickLook库和头文件
#import <QuickLook/QuickLook.h>

@interface FileSharedVC : BaseVC<UITableViewDataSource, UITableViewDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate, UIDocumentInteractionControllerDelegate>
{
    //step3. 声明显示列表
    //IBOutlet UITableView *readTable;
}

//setp4. 声明变量
//UIDocumentInteractionController : 一个文件交互控制器,提供应用程序管理与本地系统中的文件的用户交互的支持
//dirArray : 存储沙盒子里面的所有文件
@property (nonatomic, retain) NSMutableArray *dirArray;
@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

@property (nonatomic, strong) UITableView *readTable;

@end
