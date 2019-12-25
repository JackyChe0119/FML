//
//  AnimationBottomToTopBegin.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AnimationBottomToTopBegin.h"

@interface AnimationBottomToTopBegin()

@property (nonatomic, assign) CGFloat height;

@end

@implementation AnimationBottomToTopBegin


+ (instancetype)animationHeight:(CGFloat)height
{
    AnimationBottomToTopBegin *fadeBegin = [[AnimationBottomToTopBegin alloc] init];
    fadeBegin.height = height;
    return fadeBegin;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.4;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController * toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    toVC.view.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.height?:[UIScreen mainScreen].bounds.size.height);
    [[transitionContext containerView] addSubview:toVC.view];
    toVC.view.layer.zPosition = MAXFLOAT;
    //zPosition 层级 如果 toVC.view.layer.zPosition < fromVC.view.layer.zPosition 就看不到tovc了
    
    //切圆角 遮罩
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:toVC.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5,5)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = toVC.view.bounds;
    maskLayer.path = maskPath.CGPath;
    toVC.view.layer.mask = maskLayer;

    UIViewController * fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView* view = [[UIView alloc] initWithFrame:fromVC.view.frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0;
    view.tag = 9999999999;
    [fromVC.view addSubview:view];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = toVC.view.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - self.height?:[UIScreen mainScreen].bounds.size.height;
        toVC.view.frame = frame;
        view.alpha = 0.5;
    } completion:^(BOOL finished){
        [transitionContext completeTransition:YES];
    }];
}

@end
