//
//  SWBallView.m
//  BubbleTest
//
//  Created by BryanLi on 15/9/21.
//  Copyright © 2015年 mac. All rights reserved.
//

#import "SWBallView.h"
#import "SWMathTranslate.h"

@interface SWBallView ()

// 基础属性
@property (nonatomic, assign) CGPoint originalPoint;    // self原始位置
@property (nonatomic, assign) CGPoint selfPoint; // ballView自身坐标系下原始位置
@property (nonatomic, assign) CGFloat radius; // 半径
@property (nonatomic, strong) UIColor *color; // 颜色；
// 球
@property (nonatomic, strong) UIView *ballView;
@property (nonatomic, strong) UIImageView *bombImageView; // 球松开动画
// shapeLayer
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

- (void)initializeUserInterface;

// 拖拽手势
- (void)pan:(UIPanGestureRecognizer *)sender;

@end

@implementation SWBallView

- (instancetype)initWithRadius:(CGFloat)radius center:(CGPoint)center color:(UIColor *)color
{
    self = [super initWithFrame:CGRectMake(0, 0, 2.f * radius, 2.f * radius)];
    if (self) {
        self.center = center;
        self.radius = radius;
        self.color = color;
        self.originalPoint = center;
        self.selfPoint = CGPointMake(radius, radius);
        self.dismissDistance = 100;
        [self initializeUserInterface];
        [self displayViewAnimation];
    }
    return self;
}

- (void)initializeUserInterface
{
    // 初始化球
    _ballView = ({
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = _color;
        view.layer.masksToBounds = YES;
        view.layer.cornerRadius = _radius;
        [self addSubview:view];
        view;
    });
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];;
    [self.ballView addGestureRecognizer:panGesture];
    
    // layer
    _shapeLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.superview.bounds;
        layer.strokeColor = [UIColor clearColor].CGColor;
        layer.fillColor = self.color.CGColor;
        layer.masksToBounds = NO;
        layer;
    });
    [self.layer addSublayer:self.shapeLayer];
}

#pragma mark - 手势
- (void)pan:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        // 开始
        // inactively
//        [self startAnimation];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        // 位置改变
        CGPoint changePoint = [sender translationInView:sender.view];
        CGPoint newPoint = CGPointMake(_selfPoint.x + changePoint.x, _selfPoint.y + changePoint.y);
        
        // 圆球本身位置改变
        sender.view.center = newPoint;
        // 建立连接模块
        SWMathTranslate *translate = [[SWMathTranslate alloc] initWithOriginalPoint:self.selfPoint newPoint:newPoint radius:self.radius];
        if (translate.distance < self.dismissDistance) {
            // 建立路径
            UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:self.selfPoint radius:translate.expectRaidus startAngle:translate.beginStartAngle endAngle:translate.endStartAngle clockwise:YES];
            
            SWMathTranslate *reverseTranslate = [[SWMathTranslate alloc] initWithOriginalPoint:newPoint newPoint:self.selfPoint radius:self.radius];
            [path addQuadCurveToPoint:reverseTranslate.startPoint controlPoint:reverseTranslate.middlePoint];
            [path addLineToPoint:reverseTranslate.endPoint];
            [path addQuadCurveToPoint:translate.startSmallPoint controlPoint:translate.middlePoint];
            self.shapeLayer.path = path.CGPath;
        } else {
            self.shapeLayer.path = nil;
        }
        
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        // 结束
        self.shapeLayer.path = nil;
        // 判断是否最大距离
        SWMathTranslate *translate = [[SWMathTranslate alloc] initWithOriginalPoint:self.selfPoint newPoint:sender.view.center radius:self.radius];
        if (translate.distance < self.dismissDistance) {
            // 未消除
            [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.4f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                sender.view.center = self.selfPoint;
            } completion:^(BOOL finished) {
                // 未消除气泡，动画完成
                
            }];
        } else {
            // 消除
            if (self.delegate && [self.delegate respondsToSelector:@selector(ballViewDismissWithView:)]) {
                [self.delegate ballViewDismissWithView:self];
            }
            if (self.completeBlock) {
                self.completeBlock();
            }
            
            [self dismiss];
        }
    }
}

#pragma mark - 动画
- (void)startAnimation
{
    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:self.ballView.center];
    [path addLineToPoint:CGPointMake(self.ballView.center.x + self.radius/3.f, self.ballView.center.y)];
    [path addLineToPoint:CGPointMake(self.ballView.center.x - self.radius/3.f, self.ballView.center.y)];
    [path closePath];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 0.15;
    animation.path = path.CGPath;
    animation.repeatCount = 2;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    [self.ballView.layer addAnimation:animation forKey:@"startPositionAnimation"];
}

- (void)displayViewAnimation
{
    //Init ImageView
    _bombImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    _bombImageView.animationImages = @[[UIImage imageNamed:@"PPDragDropBadgeView.bundle/bomb0"],
                                       [UIImage imageNamed:@"PPDragDropBadgeView.bundle/bomb1"],
                                       [UIImage imageNamed:@"PPDragDropBadgeView.bundle/bomb2"],
                                       [UIImage imageNamed:@"PPDragDropBadgeView.bundle/bomb3"],
                                       [UIImage imageNamed:@"PPDragDropBadgeView.bundle/bomb4"]];
    _bombImageView.animationRepeatCount = 1;
    _bombImageView.animationDuration = 0.6;
    [self addSubview:_bombImageView];
}

- (void)dismiss
{
    self.shapeLayer.path = nil;
    [self.ballView removeFromSuperview];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.6];
    self.bombImageView.center = self.ballView.center;
    [self.bombImageView startAnimating];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self startAnimation];
}

@end




















