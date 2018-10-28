//
//  BinaryTreeNode.m
//  MyInsight
//
//  Created by SongMengLong on 2018/10/28.
//  Copyright © 2018 SongMenglong. All rights reserved.
//

#import "BinaryTreeNode.h"

// 二叉树节点
@implementation BinaryTreeNode

/**
 *  创建二叉排序树
 *  二叉排序树：左节点值全部小于根节点值，右节点值全部大于根节点值
 *
 *  @param values 数组
 *
 *  @return 二叉树根节点
 */
//+ (BinaryTreeNode *)createTreeWithValues:(NSArray *)values {
//
//    BinaryTreeNode *root = nil;
//    for (NSInteger i=0; i<values.count; i++) {
//        NSInteger value = [(NSNumber *)[values objectAtIndex:i] integerValue];
//        root = [BinaryTree addTreeNode:root value:value];
//    }
//    return root;
//}

/**
 *  向二叉排序树节点添加一个节点
 *
 *  @param treeNode 根节点
 *  @param value    值
 *
 *  @return 根节点
 */
//+ (BinaryTreeNode *)addTreeNode:(BinaryTreeNode *)treeNode value:(NSInteger)value {
//    //根节点不存在，创建节点
//    if (!treeNode) {
//        treeNode = [BinaryTreeNode new];
//        treeNode.value = value;
//        NSLog(@"node:%@", @(value));
//    }
//    else if (value <= treeNode.value) {
//        NSLog(@"to left");
//        //值小于根节点，则插入到左子树
//        treeNode.leftNode = [BinaryTree addTreeNode:treeNode.leftNode value:value];
//    }
//    else {
//        NSLog(@"to right");
//        //值大于根节点，则插入到右子树
//        treeNode.rightNode = [BinaryTree addTreeNode:treeNode.rightNode value:value];
//    }
//    
//    return treeNode;
//}


@end
