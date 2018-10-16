//
//  CallOutAnnotationView.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/3.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CallOutAnnotationView.h"

@interface CallOutAnnotationView()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation CallOutAnnotationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}

- (id)initWithAnnotation:(id<YMKAnnotation>)wkannotation reuseIdentifier:(NSString *)_reuseIdentifier {
    self = [super initWithAnnotation:wkannotation reuseIdentifier:_reuseIdentifier];
    if (self) {
        // 背景颜色
        self.backgroundColor = [UIColor redColor];
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, 240, 80);
        self.centerOffset = CGPointMake(105, 80);
        
        UIView *contentview = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-15, self.frame.size.height-15)];
        contentview.backgroundColor = [UIColor redColor];
        [self addSubview:contentview];
        self.contentView = contentview;
    }
    return NULL;
}



- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0, 0.0);
}

- (void)drawInContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 2.0f);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context {
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0f;
    CGFloat Arror_height = 6.0f;
    
    CGFloat minx = CGRectGetMinX(rrect);
    CGFloat midx = CGRectGetMidX(rrect);
    CGFloat maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect);
    CGFloat maxy = CGRectGetMaxY(rrect)-Arror_height;
    
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    NSLog(@"选中泡泡");
}

@end
