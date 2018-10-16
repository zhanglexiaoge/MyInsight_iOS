//
//  CancasView.m
//  MyInsight
//
//  Created by SongMengLong on 2018/6/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CancasView.h"
#import "MIBezierPath.h"

@interface CancasView()
/** path的索引 */
@property (nonatomic,strong) MIBezierPath *path;

@end

@implementation CancasView

#pragma mark - 加载Xib的初始化方法
- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    //确保开始的画笔不是橡皮
    self.rubber = NO;
}

#pragma mark - 重写的方法
-(NSMutableArray*)array{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    
    return _array;
}
-(NSMutableArray*)replayArray{
    if (_replayArray == nil) {
        _replayArray = [NSMutableArray array];
    }
    
    return _replayArray;
}

-(CancasModel *)model{
    if (_model == nil) {
        _model = [CancasModel new];
        [_model setRed:@0 green:@0.7 blue:@1 size:@5];
    }
    return _model;
}
-(void)clear{
//    if (self.array != NULL) {
        [self.array removeAllObjects];
//    }
//    if (self.replayArray != NULL) {
        [self.replayArray removeAllObjects];
//    }
    [self setNeedsDisplay];
}

#pragma mark - 手势的监听的方法
-(void)pan:(UIPanGestureRecognizer*)sender{
    
    //当我开始画一笔，就应该清除掉 "撤销数组" 里的所有步骤
    [self.replayArray removeAllObjects];
    
    
    CGPoint curP = [sender locationInView:self];
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.path = [MIBezierPath bezierPath];
        
        self.path.color = [self isRubber]?[UIColor whiteColor]:[self.model getModelColor];
        
        [self.path moveToPoint:curP];
        [self.path setLineWidth:[self.model getModelSize]];
        //设置线的连接样式
        [self.path setLineJoinStyle:kCGLineJoinRound];
        [self.array addObject:self.path];
    }else if (sender.state == UIGestureRecognizerStateChanged){
        [self.path addLineToPoint:curP];
        
        self.path.color = [self isRubber]?[UIColor whiteColor]:[self.model getModelColor];
        
        [self.path setLineWidth:[self.model getModelSize]];
        //设置线的连接样式
        [self.path setLineJoinStyle:kCGLineJoinRound];
    }
    [self setNeedsDisplay];
}

#pragma mark - 重绘要调用的方法
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    for (MIBezierPath* path in self.array) {
        //因为使用UIBezierPath曲线的颜色，必须在drawRect方法中使用才有用
        [path.color set];
        [path stroke];
    }
}

@end
