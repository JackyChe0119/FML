//
//  DateUtil.h
//  KongGeekSample
//
//  Created by Robin on 16/7/6.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATE_FORMAT_DEFAULT @"yyyy-MM-dd HH:mm:ss"
#define DATE_FORMAT_YYYYMMDDHHMMSS @"yyyyMMddHHmmss"
#define DATE_FORMAT_YYYY年MM月DD日_HH_MM_SS @"yyyy年MM月dd日 HH:mm:ss"
#define DATE_FORMAT_YYYY_MM_DD @"yyyy-MM-dd"
#define DATE_FORMAT_YYYY年MM月DD日 @"yyyy年MM月dd日"

@interface DateUtil : NSObject

//(默认格式：@"yyyy-MM-dd HH:mm:ss")
+ (NSDate *)getDateFromString:(NSString *)dateString;

+ (NSDate *)getDateFromString:(NSString *)dateString format:(NSString *)format;

//(默认格式：@"yyyy-MM-dd HH:mm:ss")
+ (NSString *)getCurrentDateString;

+ (NSString *)getCurrentDateString:(NSString *)format;
+ (NSString *)getDateStringFormString:(NSString *)interval format:(NSString *)format;
//(默认格式：@"yyyy-MM-dd HH:mm:ss")
+ (NSString *)getStringFromDate:(NSDate *)date;

+ (NSString *)getStringFromDate:(NSDate *)date format:(NSString *)format;

/** 获取时间差(秒) */
+ (NSInteger)getSecondsFromDate:(NSDate *)laterDate toDate:(NSDate *)earlierDate;

@end
