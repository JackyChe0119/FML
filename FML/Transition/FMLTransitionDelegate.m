//
//  FMLTransitionDelegate.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "FMLTransitionDelegate.h"
#import "AnimationBottomToTopBegin.h"
#import "AnimationBottomToTopEnd.h"

@implementation FMLTransitionDelegate


+ (instancetype)shareInstance
{
    static FMLTransitionDelegate *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [FMLTransitionDelegate new];
    });
    return _instance;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    id<UIViewControllerAnimatedTransitioning> objc = nil;
    switch (FMLTransitionDelegate.shareInstance.style) {
        case AnimationStyleBackScale:
            objc = [AnimationBottomToTopBegin animationHeight:_height];
            break;
        default:
            break;
    }
    return objc;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    id<UIViewControllerAnimatedTransitioning> objc = nil;
    switch (FMLTransitionDelegate.shareInstance.style) {
        case AnimationStyleBackScale:
            objc = [AnimationBottomToTopEnd animationHeight:_height];
            break;
        default:
            break;
    }
    return objc;
}

@end
