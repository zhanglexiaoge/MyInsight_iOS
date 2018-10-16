//
//  BlockVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/9/27.
//  Copyright © 2018 SongMenglong. All rights reserved.
//

#import "BlockVC.h"

@interface BlockVC ()

@end

@implementation BlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Block";
    
    //[self testBlockForHeapOfARC];
    
    //[self getBlockArray0];
}


// iOS中Block的用法，举例，解析与底层原理（这可能是最详细的Block解析）
// https://www.jianshu.com/p/bcd494ba0e22
-(void)testBlockForHeapOfARC{
    int val = 10;
    typedef void (^blk_t)(void);
    blk_t block = ^{
        NSLog(@"blk0的值:%d", val);
    };
    block();
}

#pragma mark - testBlockForHeap0 - crash
-(NSArray *)getBlockArray0{
    int val = 10;
    return [NSArray arrayWithObjects:
            ^{NSLog(@"blk0:%d", val);},
            ^{NSLog(@"blk1:%d", val);}, nil];
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
