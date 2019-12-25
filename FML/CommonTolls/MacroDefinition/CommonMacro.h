//
//  CommonErrorCode.h
//  FusionApp
//
//  Created by Ryou Zhang on 1/10/15.
//  Copyright (c) 2015 Ryou Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MainWindow [UIApplication sharedApplication].delegate.window

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#define StatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)

#define NaviBarHeight   (self.navigationController.navigationBar.frame.size.height)

#define TabBarHeight    (self.tabBarController.tabBar.frame.size.height)

#define NavHeight    (([UIApplication sharedApplication].statusBarFrame.size.height)+(self.navigationController.navigationBar.frame.size.height))

#define SafeAreaBottomHeight (ScreenHeight == 812.0 ? 34 : 0)

#define FitScale ([[UIScreen mainScreen] bounds].size.height >= 736.0 ? 1.1:1.0)

#define NumberScale(obj) ((obj) * FitScale)

#define YLSizeTransform(obj)    obj * 320 / 750

#define IPHONE5 (ScreenWidth == 320)
#define IPHONE6 (ScreenWidth == 375)
#define IPHONE6P (ScreenWidth == 414)
#define IPhoneX     (ScreenWidth == 375.f && ScreenHeight == 812.f)

#define STRING_NOT_NULL(str)  (![(str) isEqualToString:@""] && (str) != NULL)

#define UD_VERSION      @"__v"
#define UB_VERSION      @"__build"

#define BUILD_VERSION       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
#define CLIENT_VERSION      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define FOLD_NUMBER_W  [UIScreen mainScreen].bounds.size.width/320.0
#define FOLD_NUMBER_H  [UIScreen mainScreen].bounds.size.height/320.0

#define DIVIDE_LINE_HEIGHT  1/[UIScreen mainScreen].scale

#ifndef DEBUG
#define NSLog(...)
#else
#define NSLog(...) NSLog(__VA_ARGS__)
#endif

#define XCODE_COLORS_ESCAPE  @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color


#define LogE(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" @"\n[文件名:%s]\n" @"[函数名:%s]\n" @"[行号:%d]\n" @"%@" XCODE_COLORS_RESET), __FILE__,__FUNCTION__,__LINE__,frmt,##__VA_ARGS__)
#define LogW(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg250,207,12;" @"\n[文件名:%s]\n" @"[函数名:%s]\n" @"[行号:%d]\n" @"%@" XCODE_COLORS_RESET), __FILE__,__FUNCTION__,__LINE__,frmt,##__VA_ARGS__)
#define LogInfo(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg76,184,73;" @"\n[文件名:%s]\n" @"[函数名:%s]\n" @"[行号:%d]\n" @"%@" XCODE_COLORS_RESET), __FILE__,__FUNCTION__,__LINE__,frmt,##__VA_ARGS__)

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored "-Warc-performSelector-leaks"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)
