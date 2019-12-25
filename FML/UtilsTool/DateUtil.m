//
//  DateUtil.m
//  KongGeekSample
//
//  Created by Robin on 16/7/6.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

//(默认格式：@"yyyy-MM-dd HH:mm:ss")
+ (NSDate *)getDateFromString:(NSString *)dateString{
    return [self getDateFromString:dateString format:DATE_FORMAT_DEFAULT];
}

+ (NSDate *)getDateFromString:(NSString *)dateString format:(NSString *)format{
    if (!format){
        format = DATE_FORMAT_DEFAULT;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:dateString];
}

//(默认格式：@"yyyy-MM-dd HH:mm:ss")
+ (NSString *)getCurrentDateString{
    return [self getStringFromDate:[NSDate date] format:DATE_FORMAT_DEFAULT];
}

+ (NSString *)getCurrentDateString:(NSString *)format{
    return [self getStringFromDate:[NSDate date] format:format];
}
+ (NSString *)getDateStringFormString:(NSString *)interval format:(NSString *)format {
    NSDate *date = [self getDateForTimeIntervalString:interval];
    return [self getStringForDate:date format:format];
}
+ (NSString *)getStringForDate:(NSDate *)date format:(NSString *)format {
    if (format == nil) format = @"MM-dd HH:mm";
    
    // 实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // 设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    // 用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}
//(默认格式：@"yyyy-MM-dd HH:mm:ss")
+ (NSString *)getStringFromDate:(NSDate *)date{
    return [self getStringFromDate:date format:DATE_FORMAT_DEFAULT];
}

+ (NSString *)getStringFromDate:(NSDate *)date format:(NSString *)format{
    if (format == nil) {
        format = DATE_FORMAT_DEFAULT;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}
/** ”时间戳“转成”Date“ */
+ (NSDate *)getDateForTimeIntervalString:(NSString *)interval {
    interval = [self stringForId:interval];  // 强转字符串
    
    if (interval.length == 13) {            // Jave类型时间戳
        NSTimeInterval timeInterval = [interval doubleValue]/1000;
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        return date;
    }
    else if (interval.length == 10) {       // PHP类型时间戳
        NSTimeInterval timeInterval = [interval doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        return date;
    }
    return nil;
}
+ (NSString *)stringForId:(id)object {
    NSString *str = (NSString *)object;
    
    if (str == nil) return @"";
    if (str == NULL) return @"";
    if ([str isKindOfClass:[NSNull class]]) return @"";
    
    str = [NSString stringWithFormat:@"%@",str];
    return str;
}
/** 获取时间差(秒) */
+ (NSInteger)getSecondsFromDate:(NSDate *)laterDate toDate:(NSDate *)earlierDate{
    NSTimeInterval laterDateInterval = [laterDate timeIntervalSince1970];
    NSTimeInterval earlierDateInterval = [earlierDate timeIntervalSince1970];
    NSTimeInterval interval = laterDateInterval - earlierDateInterval;
    return interval*1;
}
@end
