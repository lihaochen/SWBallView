//
//  SWMathTranslate.h
//  BubbleTest
//
//  Created by BryanLi on 15/9/22.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    QuadrantFirst,
    QuadrantSecond,
    QuadrantThird,
    QuadrantFour
} Quadrant;

@interface SWMathTranslate : NSObject

@property (nonatomic, assign) CGFloat distance; // 两球距离
@property (nonatomic, assign) CGFloat expectRaidus; // 起始位置半径
@property (nonatomic, assign) Quadrant quadrant; // 象限
@property (nonatomic, assign) CGFloat beginStartAngle; // 开始角度
@property (nonatomic, assign) CGFloat endStartAngle; // 结束角度
@property (nonatomic, assign) CGPoint startPoint; // 开始位置
@property (nonatomic, assign) CGPoint endPoint; // 结束位置
@property (nonatomic, assign) CGPoint middlePoint; // 中间位置
@property (nonatomic, assign) CGPoint startSmallPoint; // 小点起始位置

- (instancetype)initWithOriginalPoint:(CGPoint)originalPoint newPoint:(CGPoint)newPoint radius:(CGFloat)radius;

@end
