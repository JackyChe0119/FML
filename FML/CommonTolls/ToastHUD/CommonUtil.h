//
//  CommonUtil.h
//  iOS SDK
//
//  Created by 王振 on 16/1/6.
//  Copyright © 2016年 杭州空极科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface CommonUtil : NSObject<UIApplicationDelegate>
//获取单例
+ (AppDelegate *)appDelegate;
/**
 *  获取一个UUID
 *
 *  @return UUID
 */
+ (NSString *)createUUID;

/**
 *  获取当前版本号
 *
 *  @return 版本号字符串
 */
+ (NSString *)getVersionNmuber;

/**
 *  获取appdegate
 *
 *  @return appdelegate
 */
+ (AppDelegate *)appdegate;

/**
 *  获取window
 *
 *  @return window
 */
+ (UIWindow *)window;

#pragma mark - 关于"NSUserDefaults"快捷方法

/**
 *  保存数据 - NSUserDefaults
 *  注：必须NSUserDefaults 识别的类型
 *
 *  @param object   value
 *  @param key      key
 */
+ (void)setInfo:(id)info forKey:(NSString *)key;

/**
 *  获取数据 - NSUserDefaults
 *
 *  @param key key
 *
 *  @return value
 */
+ (id)getInfoWithKey:(NSString *)key;

/**
 *  删除数据 - NSUserDefaults
 *
 *  @param key key
 */
+ (void)removeInfoWithKey:(NSString *)key;

#pragma mark - 关于accesstoken

/**
 *  判断是否含有 accessToken
 *
 *  @return YES？NO
 */
+ (BOOL)isHaveAccessToken;

/**
 *  获取 accessToken
 *
 *  @return YES？NO
 */
+ (NSString *)getAccessToken;

/**
 *  移除 accessToken
 *
 *  @return YES？NO
 */
+ (void)removeAccessToken;

#pragma mark - 关于时间

/** 知道时间，计算出是周几 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

#pragma mark - 关于时间方法

/** ”时间戳“转成”Date“ */
+ (NSDate *)getDateForTimeIntervalString:(NSString *)interval;

/** Date转"时间戳"字符串（0.PHP类型-10位 1.Jave-13位） */
+ (NSString *)getTimeIntervalForDate:(NSDate *)date byType:(NSInteger)type;

/** 获取当前时间的“时间戳” -- 默认13位 */
+ (NSString *)getTimeIntervalStringByNew;

/** 时间戳 直接转成 NSString (自定义 默认格式：@"yyyy-MM-dd HH:mm:ss") */
+ (NSString *)getStringForTimeIntervalString:(NSString *)interval format:(NSString *)format;

#pragma mark -

/**
 Date 转换 NSString
 (自定义 默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSString *)getStringForDate:(NSDate *)date format:(NSString *)format;

/**
 Date 转换 NSString
 (默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSString *)getStringForDate:(NSDate *)date;

/** NSString 转换 Date
 (自定义 默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSDate *)getDateForString:(NSString *)string format:(NSString *)format;

/**
 NSString 转换 Date
 (默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSDate *)getDateForString:(NSString *)string;

/**
 DateNSString 转换 NSString
 (默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSString *)getStringForDateString:(NSString *)string byFormat:(NSString *)byFormat toFormat:(NSString *)toFormat;

#pragma mark -

/** 获取时间差(秒) */
+ (NSInteger)getSecondForFromDate:(NSDate *)fromdate toDate:(NSDate *)todate;

/**
 *  返回是否有网络
 *
 *  @return
 */
+ (BOOL)noNetwork;

//是否格式为 包含字母和数字，且只包含数字、字母、下划线
+(BOOL)checkIsHaveNumAndLetter:(NSString*)password;
//图片压缩到指定大小
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withimage:(UIImage*)image;
@end

