//
//  CommonUtil.m
//  iOS SDK
//
//  Created by 王振 on 16/1/6.
//  Copyright © 2016年 杭州空极科技有限公司. All rights reserved.
//

#import "CommonUtil.h"

#define K_ACCESS_TOKEN_COMMONUTIL @"accessToken"

@implementation CommonUtil
+ (AppDelegate *)appDelegate {
    
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}
/** 获取对象的字符串类型 */
+ (NSString *)stringForId:(id)object {
    NSString *str = (NSString *)object;
    
    if (str == nil) return @"";
    if (str == NULL) return @"";
    if ([str isKindOfClass:[NSNull class]]) return @"";
    
    str = [NSString stringWithFormat:@"%@",str];
    return str;
}
/**
 *  获取一个UUID
 *
 *  @return UUID
 */
+ (NSString *)createUUID {
//    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
//    NSString * uuidStr = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));
//    CFRelease(uuidObject);
    NSString *uuidStr = [[UIDevice currentDevice].identifierForVendor UUIDString];
    return uuidStr;
}



+ (NSString *)getVersionNmuber {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}

/**
 *  获取appdegate
 *
 *  @return appdelegate
 */
+ (AppDelegate *)appdegate {
    return [UIApplication sharedApplication].delegate;
}

/**
 *  获取window
 *
 *  @return window
 */
+ (UIWindow *)window {
    return [UIApplication sharedApplication].delegate.window;
}

/**
 *  保存数据 - NSUserDefaults
 *  注：必须NSUserDefaults 识别的类型
 *
 *  @param object   value
 *  @param key      key
 */
+ (void)setInfo:(id)info forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:info forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  获取数据 - NSUserDefaults
 *
 *  @param key key
 *
 *  @return value
 */
+ (id)getInfoWithKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

/**
 *  删除数据 - NSUserDefaults
 *
 *  @param key key
 */
+ (void)removeInfoWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 关于accessToken

/**
 *  判断是否含有 accessToken
 *
 *  @return YES？NO
 */
+ (BOOL)isHaveAccessToken {
    NSString *token = [CommonUtil getInfoWithKey:K_ACCESS_TOKEN_COMMONUTIL];
    if (token == (NSString *)nil) {
        return NO;
    } else  {
        return YES;
    }
}
/**
 *  获取 accessToken
 *
 *  @return YES？NO
 */
+ (NSString *)getAccessToken {
    NSString *token = [CommonUtil getInfoWithKey:K_ACCESS_TOKEN_COMMONUTIL];
    if ([self isHaveAccessToken]) {
        return token;
    } else {
        return nil;
    }
}
/**
 *  移除 accessToken
 *
 *  @return YES？NO
 */
+ (void)removeAccessToken {
    [CommonUtil removeInfoWithKey:K_ACCESS_TOKEN_COMMONUTIL];
}
/** 知道时间，计算出是周几 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}
#pragma mark - 关于时间方法

/** ”时间戳“转成”Date“ */
+ (NSDate *)getDateForTimeIntervalString:(NSString *)interval {
    interval = [CommonUtil stringForId:interval];  // 强转字符串
    
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

/** Date转"时间戳"字符串（0.PHP类型-10位 1.Jave-13位） */
+ (NSString *)getTimeIntervalForDate:(NSDate *)date byType:(NSInteger)type {
    NSTimeInterval time;
    if (type == 1) {
        time = [date timeIntervalSince1970]*1000;
    }
    else {
        time = [date timeIntervalSince1970];
    }
    
    NSString *returnTime = [NSString stringWithFormat:@"%f",time];
    if (returnTime.length > 13) {
        returnTime = [returnTime substringToIndex:13];
    }
    
    return returnTime;
}

/** 获取当前时间的“时间戳” -- 默认13位 */
+ (NSString *)getTimeIntervalStringByNew {
    NSDate *date = [NSDate date];
    NSString *returnTime = [self getTimeIntervalForDate:date byType:1];
    return returnTime;
}

/** 时间戳 直接转成 NSString (自定义 默认格式：@"yyyy-MM-dd HH:mm:ss") */
+ (NSString *)getStringForTimeIntervalString:(NSString *)interval format:(NSString *)format {
    NSDate *date = [self getDateForTimeIntervalString:interval];
    return [self getStringForDate:date format:format];
}

#pragma mark -

/**
 Date 转换 NSString
 (自定义 默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSString *)getStringForDate:(NSDate *)date format:(NSString *)format {
    if (format == nil) format = @"yyyy-MM-dd HH:mm";
    
    // 实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // 设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    
    // 用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

/**
 Date 转换 NSString
 (默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSString *)getStringForDate:(NSDate *)date {
    return [self getStringForDate:date format:nil];
}

/** NSString 转换 Date
 (自定义 默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSDate *)getDateForString:(NSString *)string format:(NSString *)format {
    if (format == nil) format = @"yyyy-MM-dd HH:mm:ss";
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    return [dateFormatter dateFromString:string];
}

/**
 NSString 转换 Date
 (默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSDate *)getDateForString:(NSString *)string {
    return [self getDateForString:string format:nil];
}

/**
 DateNSString 转换 NSString
 (默认格式：@"yyyy-MM-dd HH:mm:ss")
 */
+ (NSString *)getStringForDateString:(NSString *)string byFormat:(NSString *)byFormat toFormat:(NSString *)toFormat {
    NSDate *date = [self getDateForString:string format:byFormat];
    NSString *dateString = [self getStringForDate:date format:toFormat];
    return dateString;
}

#pragma mark -


/** 获取时间差(秒) */
+ (NSInteger)getSecondForFromDate:(NSDate *)fromdate toDate:(NSDate *)todate {
    NSTimeInterval fromInt = [fromdate timeIntervalSince1970];  // 获取离1970年间隔
    NSTimeInterval toInt = [todate timeIntervalSince1970];
    
    NSTimeInterval interval = toInt - fromInt;  // 获取时间差值
    return interval*1;
}

/*
 获取指定时间间隔“秒”后的新时间
 “interval”:单位“秒”，如果想要分钟传“X*60”，其他同理
 */
+ (NSDate *)getDateForIntervalTime:(NSInteger)interval fromDate:(NSDate *)oldDate {
    return [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([oldDate timeIntervalSinceReferenceDate] + interval)];
}

/**
 获取与当前时间间隔“秒”后的新时间
 “interval”:单位“秒”，如果想要分钟传“X*60”，其他同理
 */
+ (NSDate *)getDateForIntervalTime:(NSInteger)interval {
    return [self getDateForIntervalTime:interval fromDate:[NSDate new]];
}


/** 取得时间差
 fromDate.开始时间
 toDate.结束时间
 type.“yyyy”-年 “MM”-月 “dd”-天 “HH”-小时 "mm"-分 “ss”-秒
 */
+ (NSInteger)getTimeDifference:(NSDate *)fromdate toDate:(NSDate *)todate byType:(NSString *)type {
    // 获取开始时间
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate:fromdate];
    NSDate *fromDate = [fromdate dateByAddingTimeInterval:frominterval];
    if (fromDate == nil) return 0;
    
    // 获取结束时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:todate];
    NSDate *toDate = [todate dateByAddingTimeInterval:interval];
    
    // 获取时间差
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *components = [gregorian components:unitFlags fromDate:fromDate toDate:toDate options:0];
    
    if ([@"yyyy" isEqualToString:type]) {
        return [components year];
    }
    if ([@"MM" isEqualToString:type]) {
        return [components month];
    }
    if ([@"dd" isEqualToString:type]) {
        return [components day];
    }
    if ([@"HH" isEqualToString:type]) {
        return [components hour];
    }
    if ([@"mm" isEqualToString:type]) {
        return [components minute];
    }
    if ([@"ss" isEqualToString:type]) {
        return [components second];
    }
    
    return 0;
}


/**
 将秒数变成“00:00”格式的显示
 format. "mm分ss秒"/"m分ss秒"/"m分s秒"/“00:00”
 */
+ (NSString *)timeFormatted:(int)totalSeconds format:(NSString *)format {
    if (totalSeconds < 0)  totalSeconds = 0;
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    if ([@"00:00" isEqualToString:format]) {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    }
    else if ([@"mm分ss秒" isEqualToString:format]) {
        return [NSString stringWithFormat:@"%02d分%02d秒", minutes, seconds];
    }
    else if ([@"m分ss秒" isEqualToString:format]) {
        return [NSString stringWithFormat:@"%d分%02d秒", minutes, seconds];
    }
    else if ([@"m分s秒" isEqualToString:format]) {
        return [NSString stringWithFormat:@"%d分%d秒", minutes, seconds];
    }
    
    return @"";
}

/**
 *  返回是否有网络
 *
 *  @return
 */

//是否格式为 包含字母和数字，且只包含数字、字母、下划线
+(BOOL)checkIsHaveNumAndLetter:(NSString*)password{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if (tNumMatchCount == 0 || tLetterMatchCount == 0) {
        return NO;
    }
    NSCharacterSet *s = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_"];
    s = [s invertedSet];
    NSRange r = [password rangeOfCharacterFromSet:s];
    if (r.location != NSNotFound){
        return NO;
    }
    return YES;
    
}

//图片压缩到指定大小
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withimage:(UIImage*)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
@end
