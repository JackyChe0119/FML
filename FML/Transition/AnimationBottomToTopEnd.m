//
//  AnimationBottomToTopEnd.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AnimationBottomToTopEnd.h"
#import "FMLTransitionDelegate.h"

@interface AnimationBottomToTopEnd()

@property (nonatomic, assign) CGFloat height;

@end

@implementation AnimationBottomToTopEnd

+ (instancetype)animationHeight:(CGFloat)height
{
    AnimationBottomToTopEnd *fadeEnd = [[AnimationBottomToTopEnd alloc] init];
    fadeEnd.height = height;
    return fadeEnd;
}
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    NSTimeInterval timer = [FMLTransitionDelegate shareInstance].timer;
    [UIView animateWithDuration: timer != 0 ? timer :  0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [toVC.view viewWithTag:9999999999].alpha = 0;
        
        CGRect frame = fromVC.view.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height;
        fromVC.view.frame = frame;
    } completion:^(BOOL finished) {
        [FMLTransitionDelegate shareInstance].timer = 0;
        [transitionContext completeTransition:YES];
        [[toVC.view viewWithTag:9999999999] removeFromSuperview];
    }];

}

@end
