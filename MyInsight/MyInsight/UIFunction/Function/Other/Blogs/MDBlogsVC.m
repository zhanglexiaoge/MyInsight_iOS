//
//  MDBlogsVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/10/17.
//  Copyright © 2018 SongMenglong. All rights reserved.
//

#import "MDBlogsVC.h"
#import "MyInsight-Swift.h" // OC混编swift

@interface MDBlogsVC ()
//
@property (nonatomic, strong) MarkdownView *mdView;

@end

@implementation MDBlogsVC

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = self.markdownStr;

	self.view.backgroundColor = [UIColor whiteColor];
	self.mdView = [[MarkdownView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:self.mdView];
	self.mdView.translatesAutoresizingMaskIntoConstraints = NO;
	[[self.mdView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.topAnchor] setActive:YES];
	[[self.mdView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor] setActive:YES];
	[[self.mdView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor] setActive:YES];
	[[self.mdView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor] setActive:YES];

	NSString *path = [[NSBundle mainBundle] pathForResource:self.markdownStr ofType:@"md"];
	NSLog(@"博客文档的路径： %@", path);
	NSURL *url = [NSURL fileURLWithPath:path];
	NSString *markdown = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
	[self.mdView loadWithMarkdown:markdown enableImage:YES];


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
