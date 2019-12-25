//
//  CommonToastHUD.m
//  Objective-C Utils
//
//  Created by 赵伟 on 15/3/4.
//  Copyright (c) 2015年 赵伟. All rights reserved.
//

#import "CommonToastHUD.h"
#import "WToast.h"
#import "DejalActivityView.h"

@implementation CommonToastHUD
/* 温馨提示 */
+ (void)showTips:(NSString *)message {
    if (!message || [@"" isEqualToString:message]) return;
    //[WToast showWithImage:[UIImage imageNamed:@"icon_alter_1.png"] withText:message];
    [WToast showWithImage:nil withText:message];
}

/** 显示锁屏提示 - 所有提示公用一个 */
+ (void)showActivityView:(UIView *)view {
    [DejalBezelActivityView activityViewForView:view];  // 显示转圈动画
}

/** 隐藏锁屏提示 */
+ (void)hideActivityViewAnimated:(BOOL)animated {
    [DejalBezelActivityView removeViewAnimated:animated];
}

@end
