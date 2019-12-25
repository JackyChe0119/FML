//
//  JSONUtil.m
//  KongGeekSample
//
//  Created by Robin on 16/7/6.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "JSONUtil.h"

@implementation JSONUtil

+(NSString *)toJSONString:(id)dataObject {
    if (!dataObject) {
        return nil;
    }
    if ([NSJSONSerialization isValidJSONObject:dataObject])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataObject options:NSJSONWritingPrettyPrinted error:&error];
        if(error) {
            return nil;
        }
        NSString *json =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return json;
    }
    return nil;
}

+(NSDictionary *)toDictionary:(NSString *)JSONString{
    if (JSONString==nil) {
        return nil;
    }
    NSData *jsonData = [JSONString dataUsingEncoding: NSUTF8StringEncoding];
    
    NSError *err;
    NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

+(NSArray *) toArray:(NSString *)JSONString  {
    if (JSONString==nil) {
        return nil;
    }
    NSData *jsonData = [JSONString dataUsingEncoding: NSUTF8StringEncoding];
    
    NSError *err;
    NSArray *array =  [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    if(err) {
        return nil;
    }
    return array;
}

@end
