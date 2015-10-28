//
//  SWBallView.h
//  BubbleTest
//
//  Created by BryanLi on 15/9/21.
//  Copyright © 2015年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWBallView;

typedef void (^CompleteBlock)();

@protocol SWBallViewDelegate <NSObject>

- (void)ballViewDismissWithView:(SWBallView *)ballView;

@end

@interface SWBallView : UIView

@property (nonatomic, assign) CGFloat dismissDistance;
@property (nonatomic, copy) CompleteBlock completeBlock;
@property (nonatomic, weak) id<SWBallViewDelegate> delegate;

- (instancetype)initWithRadius:(CGFloat)radius center:(CGPoint)center color:(UIColor *)color;

- (void)setCompleteBlock:(CompleteBlock)completeBlock;

@end
