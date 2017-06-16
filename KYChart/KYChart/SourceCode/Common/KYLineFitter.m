//
//  KYLineFitter.m
//  KYChart
//
//  Created by kangyi on 2017/6/9.
//  Copyright © 2017年 kangyi. All rights reserved.
//
// 算法参考
// http://blog.csdn.net/pl20140910/article/details/51926886


#import "KYLineFitter.h"

NSArray<NSValue *> * beelineFitting(NSArray<NSValue *> *points)
{
    float A = 0.0;
    float B = 0.0;
    float C = 0.0;
    float D = 0.0;
    
    for (int i=0; i< points.count; i++)
    {
        CGPoint point = [points[i] CGPointValue];
        A += point.x * point.x;
        B += point.x;
        C += point.x * point.y;
        D += point.y;
    }
    
    // 计算斜率a和截距b
    float a, b, temp = (points.count * A - B*B);
    if(temp)// 判断分母不为0
    {
        a = (points.count *C - B*D) / temp;
        b = (A*D - B*C) / temp;
    }
    else
    {
        a = 1;
        b = 0;
    }
    
    CGPoint poi1 = [points.firstObject CGPointValue];
    CGPoint poi2 = [points.lastObject CGPointValue];
    
    double y1 = a *poi1.x + b;
    double y2 = a *poi2.x + b;
    
    CGPoint p1 = CGPointMake(poi1.x, y1);
    CGPoint p2 = CGPointMake(poi2.x, y2);
    NSArray *retArray = @[[NSValue valueWithCGPoint:p1],[NSValue valueWithCGPoint:p2]];
    return retArray;
}
