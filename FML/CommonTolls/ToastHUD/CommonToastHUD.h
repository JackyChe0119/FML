//
//  CommonToastHUD.h
//  Objective-C Utils
//
//  Created by 赵伟 on 15/3/4.
//  Copyright (c) 2015年 赵伟. All rights reserved.
//
//  HUD提示共同方法
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonToastHUD : NSObject

/** 温馨提示 */
+ (void)showTips:(NSString *)message;

/** 显示锁屏提示 - 本提示公用一个 */
+ (void)showActivityView:(UIView *)view;

/** 隐藏锁屏提示 */
+ (void)hideActivityViewAnimated:(BOOL)animated ;

@end
