//
//  MyProgressView.m
//  TEST
//
//  Created by Megatron on 12/1/14.
//  Copyright (c) 2014 Megatron. All rights reserved.
//

#import "MyProgressView.h"

@implementation MyProgressView

@synthesize dataArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.array_Lab = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    if (self.dataArray == nil || self.dataArray.count == 0) {
        return;
    }
    // 移除原有的label
    for (UILabel *lab in self.array_Lab) {
        [lab removeFromSuperview];
    }
    
    // 坐标直线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 185/255.0, 186/255.0, 187/255.0, 0.9);
    CGContextSetLineWidth(context, 2.5);
    CGContextMoveToPoint(context, 0, 80);
    CGContextAddLineToPoint(context, rect.size.width, 80);
    CGContextStrokePath(context);
    
    if (self.type == UNIT_TYPE_HOUR) {
        // 绘制下标和单位
        TimeInfo *info1 = [self.dataArray objectAtIndex:self.leftN];
        TimeInfo *info2 = [self.dataArray objectAtIndex:self.rightN];
        
        for (int i = info1.start_Time; i < info2.end_Time ; i = i + 3600) {
            if (i % 3600 == 0) {
                float pointX1 = (i - self.middleT) / (24 * 60 * 60.0) * 24 * Unit_Hour + self.frame.size.width * 0.5;
                CGContextSetLineWidth(context, 2);
                CGContextMoveToPoint(context, pointX1, 70);
                CGContextAddLineToPoint(context, pointX1, 80);
                CGContextStrokePath(context);
                
                UILabel *lab = [[UILabel alloc] init];
                lab.bounds = CGRectMake(0, 0, 30, 20);
                lab.center = CGPointMake(pointX1, 95);
                lab.font = [UIFont fontWithName:@"Marion" size:12.0];
                int h = (i / 3600);
                lab.text = [NSString stringWithFormat:@"%@:00",h >= 10?[NSString stringWithFormat:@"%i",h]:[NSString stringWithFormat:@"0%i",h]];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = NormalFontColor;
                
                [self addSubview:lab];
                [self.array_Lab addObject:lab];
            }
            else
            {
                int s = i;
                do {
                    s = s + 1;
                } while (s % 3600 != 0);
                float pointX2 = (s - self.middleT) / (24 * 60 * 60.0) * 24 * Unit_Hour + self.frame.size.width * 0.5;
                CGContextSetLineWidth(context, 2);
                CGContextMoveToPoint(context, pointX2, 70);
                CGContextAddLineToPoint(context, pointX2, 80);
                CGContextStrokePath(context);
                
                UILabel *lab = [[UILabel alloc] init];
                lab.bounds = CGRectMake(0, 0, 30, 20);
                lab.center = CGPointMake(pointX2, 95);
                lab.font = [UIFont fontWithName:@"Marion" size:12.0];
                int h = (s / 3600);
                lab.text = [NSString stringWithFormat:@"%@:00",h >= 10?[NSString stringWithFormat:@"%i",h]:[NSString stringWithFormat:@"0%i",h]];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = NormalFontColor;
                
                [self addSubview:lab];
                [self.array_Lab addObject:lab];
            }
        }
        
        for (int i = (self.leftN - 1)>=0?self.leftN - 1:0;i <= self.rightN; i ++) {
            TimeInfo *info = [self.dataArray objectAtIndex:i];
            
            if (info.type == TYPE_ALARM) {
                CGContextSetRGBStrokeColor(context, 245/255.0, 38/255.0, 65/255.0, 1);
            }
            else if ( info.type == TYPE_NONE )
            {
                CGContextSetRGBStrokeColor(context, 177/255.0, 174/255.0, 177/255.0, 1);
            }
            else if ( info.type == TYPE_NORMAL )
            {
                CGContextSetRGBStrokeColor(context, 22/255.0, 159/255.0, 244/255.0, 1);
            }
            else if ( info.type == TYPE_DETECTION)
            {
                CGContextSetRGBStrokeColor(context, 232/255.0, 114/255.0, 0/255.0, 1);
            }
            else if ( info.type == TYPE_HAND)
            {
                CGContextSetRGBStrokeColor(context, 9/255.0, 250/255.0, 149/255.0, 1);
            }
            
            float startX = ((info.start_Time - self.middleT) / (24.0*60*60) * Unit_Hour * 24) + rect.size.width * 0.5;
            float endX = ((info.end_Time - self.middleT) / (24.0*60*60) * Unit_Hour * 24) + rect.size.width * 0.5;
            
            CGContextSetLineWidth(context, 25);
            CGContextMoveToPoint(context, startX, 50);
            CGContextAddLineToPoint(context, endX + 1, 50);
            CGContextStrokePath(context);
        }
        
    }
    else if (self.type == UNIT_TYPE_MINUTE)
    {
        // 绘制下标和单位
        TimeInfo *info1 = [self.dataArray objectAtIndex:self.leftN];
        TimeInfo *info2 = [self.dataArray objectAtIndex:self.rightN];
        for (int i = info1.start_Time; i < info2.end_Time ; i = i + 600) {
            if (i % 600 == 0) {
                float pointX1 = (i - self.middleT) / (24 * 60 * 60.0) * 24 * 6 * Unit_Minute + self.frame.size.width * 0.5;
                CGContextSetLineWidth(context, 2);
                CGContextMoveToPoint(context, pointX1, 70);
                CGContextAddLineToPoint(context, pointX1, 80);
                CGContextStrokePath(context);
                
                UILabel *lab = [[UILabel alloc] init];
                lab.bounds = CGRectMake(0, 0, 30, 20);
                lab.center = CGPointMake(pointX1, 95);
                lab.font = [UIFont fontWithName:@"Marion" size:12.0];
                lab.text = [self getMinuteStringWithSecond:(i - (i % 60))];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = NormalFontColor;
                
                [self addSubview:lab];
                [self.array_Lab addObject:lab];
            }
            else
            {
                int s = i;
                do {
                    s = s + 1;
                } while (s % 600 != 0);
                float pointX2 = (s - self.middleT) / (24 * 60 * 60.0) * 24 * 6 * Unit_Minute + self.frame.size.width * 0.5;
                CGContextSetLineWidth(context, 2);
                CGContextMoveToPoint(context, pointX2, 70);
                CGContextAddLineToPoint(context, pointX2, 80);
                CGContextStrokePath(context);
                
                UILabel *lab = [[UILabel alloc] init];
                lab.bounds = CGRectMake(0, 0, 30, 20);
                lab.center = CGPointMake(pointX2, 95);
                lab.font = [UIFont fontWithName:@"Marion" size:12.0];
                s = s - (s % 60);
                lab.text = [self getMinuteStringWithSecond:s];
                lab.textAlignment = NSTextAlignmentCenter;
                lab.textColor = NormalFontColor;
                
                [self addSubview:lab];
                [self.array_Lab addObject:lab];
            }
        }
        
        for (int i = (self.leftN - 1)>=0?self.leftN - 1:0;i <= self.rightN; i ++) {
            TimeInfo *info = [self.dataArray objectAtIndex:i];
            if (info.type == TYPE_ALARM) {
                CGContextSetRGBStrokeColor(context, 245/255.0, 38/255.0, 65/255.0, 1);
            }
            else if ( info.type == TYPE_NONE )
            {
                CGContextSetRGBStrokeColor(context, 177/255.0, 174/255.0, 177/255.0, 1);
            }
            else if ( info.type == TYPE_NORMAL )
            {
                CGContextSetRGBStrokeColor(context, 22/255.0, 159/255.0, 244/255.0, 1);
            }
            else if ( info.type == TYPE_DETECTION)
            {
                CGContextSetRGBStrokeColor(context, 232/255.0, 114/255.0, 0/255.0, 1);
            }
            else if ( info.type == TYPE_HAND)
            {
                CGContextSetRGBStrokeColor(context, 9/255.0, 250/255.0, 149/255.0, 1);
            }
            
            float startX = ((info.start_Time - self.middleT) / (24.0*60*60) * Unit_Minute * 6 * 24) + rect.size.width * 0.5;
            float endX = ((info.end_Time - self.middleT) / (24.0*60*60) * Unit_Minute * 6 * 24) + rect.size.width * 0.5;
            
            CGContextSetLineWidth(context, 25);          // 25 时间轴的粗细程度
            CGContextMoveToPoint(context, startX, 50);
            CGContextAddLineToPoint(context, endX + 1, 50);   // +1 防止出现白色细缝
            CGContextStrokePath(context);
        }
        
        
    }
    else if (self.type == UNIT_TYPE_SECOND) {
        
        // 绘制下标和单位
        TimeInfo *info1 = [self.dataArray objectAtIndex:self.leftN];
        TimeInfo *info2 = [self.dataArray objectAtIndex:self.rightN];
        for (int i = info1.start_Time; i < info2.end_Time ; i = i + 10) {
            if (i % 10 == 0) {
                float pointX1 = (i - self.middleT) / (24 * 60 * 60.0) * 24 * 60 * 6 * Unit_Second + self.frame.size.width * 0.5;
                if (pointX1 >= 0 || pointX1 <= rect.size.width) {
                    CGContextSetLineWidth(context, 2);
                    CGContextMoveToPoint(context, pointX1, 70);
                    CGContextAddLineToPoint(context, pointX1, 80);
                    CGContextStrokePath(context);
                    
                    UILabel *lab = [[UILabel alloc] init];
                    lab.bounds = CGRectMake(0, 0, 50, 20);
                    lab.center = CGPointMake(pointX1, 95);
                    lab.font = [UIFont fontWithName:@"Marion" size:12.0];
                    lab.text = [self getSecondStringWithSecond:(i - (i % 10))];
                    lab.textAlignment = NSTextAlignmentCenter;
                    lab.textColor = NormalFontColor;
                    
                    [self addSubview:lab];
                    [self.array_Lab addObject:lab];
                }
                
            }
            else
            {
                int s = i;
                do {
                    s = s + 1;
                } while (s % 600 != 0);
                
                float pointX2 = (s - self.middleT) / (24 * 60 * 60.0) * 24 * 60 * 6 * Unit_Second + self.frame.size.width * 0.5;
                
                if (pointX2 >= 0 || pointX2 <= rect.size.width) {
                    CGContextSetLineWidth(context, 2);
                    CGContextMoveToPoint(context, pointX2, 70);
                    CGContextAddLineToPoint(context, pointX2, 80);
                    CGContextStrokePath(context);
                    
                    UILabel *lab = [[UILabel alloc] init];
                    lab.bounds = CGRectMake(0, 0, 50, 20);
                    lab.center = CGPointMake(pointX2, 95);
                    lab.font = [UIFont fontWithName:@"Marion" size:12.0];
                    s = s - (s % 10);
                    lab.text = [self getSecondStringWithSecond:s];
                    lab.textAlignment = NSTextAlignmentCenter;
                    lab.textColor = NormalFontColor;
                    
                    [self addSubview:lab];
                    [self.array_Lab addObject:lab];
                }
            }
        }
        
        for (int i = (self.leftN - 1) >= 0 ? self.leftN - 1 : 0;i <= self.rightN; i ++) {

            TimeInfo *info = [self.dataArray objectAtIndex:i];
            if (info.type == TYPE_ALARM) {
                CGContextSetRGBStrokeColor(context, 245/255.0, 38/255.0, 65/255.0, 1);
            }
            else if ( info.type == TYPE_NONE )
            {
                CGContextSetRGBStrokeColor(context, 177/255.0, 174/255.0, 177/255.0, 1);
            }
            else if ( info.type == TYPE_NORMAL )
            {
                CGContextSetRGBStrokeColor(context, 22/255.0, 159/255.0, 244/255.0, 1);
            }
            else if ( info.type == TYPE_DETECTION)
            {
                CGContextSetRGBStrokeColor(context, 232/255.0, 114/255.0, 0/255.0, 1);
            }
            else if ( info.type == TYPE_HAND)
            {
                CGContextSetRGBStrokeColor(context, 9/255.0, 250/255.0, 149/255.0, 1);
            }
            
            float startX = ((info.start_Time - self.middleT) / (24.0*60*60) * Unit_Second * 6 * 60 * 24) + rect.size.width * 0.5;
            float endX = ((info.end_Time - self.middleT) / (24.0*60*60) * Unit_Second * 6 * 60 * 24) + rect.size.width * 0.5;
            if (startX < 0) {
                startX = 0;
            }
            if (endX > rect.size.width) {
                endX = rect.size.width;
            }
            
            CGContextSetLineWidth(context, 25);
            CGContextMoveToPoint(context, startX, 50);
            CGContextAddLineToPoint(context, endX + 1, 50);
            CGContextStrokePath(context);
        }
        
    }
}

-(void)refreshViewWithDataFrom:(int)leftNum to:(int)rightNum andMiddleNum:(int)standardNum andMiddleTime:(int)second andType:(enum Unit_Type)type
{
    self.standardN = standardNum;
    self.leftN = leftNum;
    self.rightN = rightNum;
    self.type = type;
    self.middleT = second;
    if (self.middleT < 0) {
        self.middleT = 0;
    }
    else if (self.middleT > (24*60*60))
    {
        self.middleT = 24*60*60;
    }
    [self setNeedsDisplay];
}

-(NSString *)getMinuteStringWithSecond:(int)second
{
    int h = second / 3600;
    int m = (second % 3600) / 60;
    NSString *str = [NSString stringWithFormat:@"%@:%@",h>=10?[NSString stringWithFormat:@"%i",h]:[NSString stringWithFormat:@"0%i",h],m>=10?[NSString stringWithFormat:@"%i",m]:[NSString stringWithFormat:@"0%i",m]];
    return str;
}

-(NSString *)getSecondStringWithSecond:(int)second
{
    int h = second / 3600;
    int m = (second % 3600) / 60;
    int s = ((second % 3600) % 60);
    NSString *str = [NSString stringWithFormat:@"%@:%@:%@",h>=10?[NSString stringWithFormat:@"%i",h]:[NSString stringWithFormat:@"0%i",h],m>=10?[NSString stringWithFormat:@"%i",m]:[NSString stringWithFormat:@"0%i",m],s>=10?[NSString stringWithFormat:@"%i",s]:[NSString stringWithFormat:@"0%i",s]];
    return str;
}

-(void)modefy
{
    
}

@end
