//
//  FileSharedVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/5/15.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "FileSharedVC.h"

@interface FileSharedVC ()

@end

@implementation FileSharedVC

//@synthesize dirArray;
//@synthesize docInteractionController;

/*
 [iOS开发- 文件共享(利用iTunes导入文件, 并且显示已有文件)](https://blog.csdn.net/hitwhylz/article/details/29389939)
 [源码下载](https://github.com/zhglinux/iTunesTest)
 [iTunes开发API用来下载歌曲信息](https://github.com/chengtanze/iTunesTest)
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // 标题
    self.title = @"文件共享";
    
    // 创建列表
    self.readTable = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:self.readTable];
    self.readTable.delegate = self;
    self.readTable.dataSource = self;
    self.readTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 把分享文件写入到沙盒路径下
    [self saveShareFileToDocument];
    // 读取沙盒路径下的文件
    [self readFilePathDocument];
}

// 保存分享文件到文档文件夹中 沙盒路径
- (void)saveShareFileToDocument {
    //step5. 保存一张图片到设备document文件夹中(为了测试方便)
    UIImage *image = [UIImage imageNamed:@"testPic.jpg"];
    NSData *jpgData = UIImageJPEGRepresentation(image, 0.8);
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"testPic.jpg"]; //Add the file name
    [jpgData writeToFile:filePath atomically:YES]; //Write the file
    
    //step5. 保存一份txt文件到设备document文件夹中(为了测试方便)
    char *saves = "Colin_csdn";
    NSData *data = [[NSData alloc] initWithBytes:saves length:10];
    filePath = [documentsPath stringByAppendingPathComponent:@"colin.txt"];
    [data writeToFile:filePath atomically:YES];
    
    char *saves1 = "Hello World!";
    NSData *data1 = [[NSData alloc] initWithBytes:saves1 length:12];
    filePath = [documentsPath stringByAppendingPathComponent:@"WTF.txt"];
    [data1 writeToFile:filePath atomically:YES];
}

// 读取沙盒路径下的文件
- (void)readFilePathDocument {
    //step6. 获取沙盒里所有文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    
    self.dirArray = [[NSMutableArray alloc] init];
    for (NSString *file in fileList) {
        [self.dirArray addObject:file];
    }
    
    //step6. 刷新列表, 显示数据
    [self.readTable reloadData];
}

//step7. 利用url路径打开UIDocumentInteractionController
- (void)setupDocumentControllerWithURL:(NSURL *)url {
    if (self.docInteractionController == nil) {
        self.docInteractionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        self.docInteractionController.delegate = self;
    } else {
        self.docInteractionController.URL = url;
    }
}

#pragma mark- 列表操作
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 生成cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellName = @"CellName";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellName];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSURL *fileURL= nil;
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:indexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    
    [self setupDocumentControllerWithURL:fileURL];
    cell.textLabel.text = [self.dirArray objectAtIndex:indexPath.row];
    NSInteger iconCount = [self.docInteractionController.icons count];
    if (iconCount > 0) {
        cell.imageView.image = [self.docInteractionController.icons objectAtIndex:iconCount - 1];
    }
    
    return cell;
}

// cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dirArray count];
}

// 选择cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.dataSource = self;
    previewController.delegate = self;
    
    //start previewing the document at the current section index
    previewController.currentPreviewItemIndex = indexPath.row;
    [[self navigationController] pushViewController:previewController animated:YES];
    //[self presentViewController:previewController animated:YES completion:nil];
}

#pragma mark -  实现UIDocumentInteractionControllerDelegate相关协议
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController {
    return self;
}


#pragma mark - QLPreviewControllerDataSource
// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController {
    return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx {
    NSURL *fileURL = nil;
    NSIndexPath *selectedIndexPath = [self.readTable indexPathForSelectedRow];
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSString *path = [documentDir stringByAppendingPathComponent:[self.dirArray objectAtIndex:selectedIndexPath.row]];
    fileURL = [NSURL fileURLWithPath:path];
    return fileURL;
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
