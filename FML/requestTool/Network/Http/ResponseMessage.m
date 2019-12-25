//
//  ResponseMessage.m
//  KongGeekSample
//
//  Created by Robin on 16/7/5.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "ResponseMessage.h"

@implementation ResponseMessage

-(instancetype) init{
    self = [super init];
    if (self) {
        _responseState=ResponseNotFinish;
    }
    return self;
}

- (instancetype)initWithRequestUrl:(NSString *)requestUrl requestArgs:(NSDictionary *)requestArgs{
    self = [super init];
    if (self) {
        _requestUrl=requestUrl;
        _requestArgs=requestArgs;
        _responseState=ResponseNotFinish;
    }
    return self;
}
- (BOOL)isSuccessful {
    if ( [self.retCode integerValue]==0) {
        return YES;
    }
    return NO;
}
@end
