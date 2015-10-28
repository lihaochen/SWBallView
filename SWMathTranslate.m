//
//  SWMathTranslate.m
//  BubbleTest
//
//  Created by BryanLi on 15/9/22.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SWMathTranslate.h"

#define UNITVECTOR CGPointMake(1, 0)
#define RADIAN M_PI/2

@interface SWMathTranslate ()

@property (nonatomic, assign) CGPoint originalPoint; // 起始位置 （已切换为坐标系位置）
@property (nonatomic, assign) CGPoint newPoint; // 新位置 （已切换为坐标系位置）
@property (nonatomic, assign) CGFloat radius; // 原球大小

@property (nonatomic, assign) CGFloat radian; // 角度大小

@end

@implementation SWMathTranslate

- (instancetype)initWithOriginalPoint:(CGPoint)originalPoint newPoint:(CGPoint)newPoint radius:(CGFloat)radius
{
    self = [self init];
    if (self) {
        self.originalPoint = [SWMathTranslate openGLPointFromUIKitPoint:originalPoint referenceHeight:radius * 2];
        self.newPoint = [SWMathTranslate openGLPointFromUIKitPoint:newPoint referenceHeight:radius * 2];
        self.radius = radius;
        _radian = RADIAN;
        [self judgmentQuadrant]; // 判断象限
    }
    return self;
}

- (void)judgmentQuadrant
{
    CGPoint point = [self coordinateExpression];
    if (point.x > 0) {
        if (point.y > 0) {
            self.quadrant = QuadrantFirst;
        } else {
            self.quadrant = QuadrantFour;
        }
    } else {
        if (point.y > 0) {
            self.quadrant = QuadrantSecond;
        } else {
            self.quadrant = QuadrantThird;
        }
    }
}

- (CGPoint)coordinateExpression
{
    CGPoint p = CGPointZero;
    p.x = self.newPoint.x - self.originalPoint.x;
    p.y = self.newPoint.y - self.originalPoint.y;
    return p;
}

#pragma mark - getter
- (CGFloat)distance
{
    return sqrt(pow((_originalPoint.y - _newPoint.y), 2) + pow((_originalPoint.x - _newPoint.x), 2));
}

- (CGFloat)expectRaidus
{
    return self.radius * self.radius / (self.distance/3.f + self.radius);
}

- (CGFloat)radian
{
    CGFloat radian = RADIAN - M_PI/8;
    NSLog(@"%lf", radian * radian / (self.distance/100.f + radian) + M_PI/8);
    return radian * radian / (self.distance/100.f + radian) + M_PI/8;
}

- (CGFloat)beginStartAngle
{
    CGPoint newUnitvector = [self coordinateExpression];
    newUnitvector = CGPointMake(newUnitvector.x / self.distance, newUnitvector.y / self.distance);
    CGFloat angle = acos(newUnitvector.x * UNITVECTOR.x + newUnitvector.y * UNITVECTOR.y);
    if (self.quadrant == QuadrantFirst || self.quadrant == QuadrantSecond) {
        angle = -angle;
    }
    angle += self.radian;
    return angle;
}

- (CGFloat)endStartAngle
{
    return self.beginStartAngle - self.radian*2 + M_PI*2;
}

- (CGPoint)startPoint
{
    CGFloat angle = self.beginStartAngle;
    CGPoint newPoint = [SWMathTranslate uikitPointFromOpenGLPoint:self.originalPoint referenceHeight:self.radius * 2];
    CGPoint p = CGPointZero;
    p.x = newPoint.x + self.radius * cos(angle);
    p.y = newPoint.y + self.radius * sin(angle);
    return p;
}

- (CGPoint)endPoint
{
    CGFloat angle = self.endStartAngle;
    CGPoint p = CGPointMake(self.radius * cos(angle), -self.radius * sin(angle));
    p.x += self.originalPoint.x;
    p.y += self.originalPoint.y;
    p = [SWMathTranslate uikitPointFromOpenGLPoint:p referenceHeight:self.radius * 2];
    return p;
}

- (CGPoint)startSmallPoint
{
    CGFloat angle = self.beginStartAngle;
    CGPoint p = CGPointMake(self.expectRaidus * cos(angle), -self.expectRaidus * sin(angle));
    p.x += self.originalPoint.x;
    p.y += self.originalPoint.y;
    p = [SWMathTranslate uikitPointFromOpenGLPoint:p referenceHeight:self.radius * 2];
    return p;
}

- (CGPoint)middlePoint
{
    return [SWMathTranslate uikitPointFromOpenGLPoint:CGPointMake((self.originalPoint.x + self.newPoint.x)/2, (self.originalPoint.y + self.newPoint.y)/2) referenceHeight:self.radius * 2];
}

#pragma mark - 坐标转换
+ (CGPoint)openGLPointFromUIKitPoint:(CGPoint)point referenceHeight:(CGFloat)height
{
    CGPoint p = CGPointZero;
    p.x = point.x;
    p.y = height - point.y;
    
    return p;
}

+ (CGPoint)uikitPointFromOpenGLPoint:(CGPoint)point referenceHeight:(CGFloat)height
{
    CGPoint p = CGPointZero;
    p.x = point.x;
    p.y = height - point.y;
    
    return p;
}


@end
























