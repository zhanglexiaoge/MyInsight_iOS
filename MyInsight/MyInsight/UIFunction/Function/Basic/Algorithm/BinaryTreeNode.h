//
//  BinaryTreeNode.h
//  MyInsight
//
//  Created by SongMengLong on 2018/10/28.
//  Copyright © 2018 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BinaryTreeNode : NSObject

/**
 *  值
 */
@property (nonatomic, assign) NSInteger value;
/**
 *  左节点
 */
@property (nonatomic, strong) BinaryTreeNode *leftNode;
/**
 *  右节点
 */
@property (nonatomic, strong) BinaryTreeNode *rightNode;


@end

NS_ASSUME_NONNULL_END
