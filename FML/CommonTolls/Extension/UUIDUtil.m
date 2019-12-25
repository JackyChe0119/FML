//
//  UUIDUtil.m
//  H3CMagic
//
//  Created by Robin on 15/12/22.
//  Copyright © 2015年 KongGeek. All rights reserved.
//

#import "UUIDUtil.h"

@implementation UUIDUtil

+(NSString *)generateUUID{
    CFUUIDRef theUUID =CFUUIDCreate(NULL);
    CFStringRef guid = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *uuidString = [((__bridge NSString *)guid)stringByReplacingOccurrencesOfString:@"-"withString:@""];
    CFRelease(guid);
    return uuidString;
}

@end
