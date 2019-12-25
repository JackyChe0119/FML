//
//  JSONUtil.h
//  KongGeekSample
//
//  Created by Robin on 16/7/6.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONUtil : NSObject

//将对象（如dictionary）转化为json
+(NSString *) toJSONString:(id)dataObject;

//将json字符串转化为dictionary
+(NSDictionary *) toDictionary:(NSString *)JSONString;

//将json字符串转化为dictionary
+(NSArray *) toArray:(NSString *)JSONString;
@end
