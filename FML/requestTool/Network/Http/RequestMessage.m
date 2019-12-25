//
//  RequestMessage.m
//  KongGeekSample
//
//  Created by Robin on 16/7/5.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "RequestMessage.h"
#import "CommonUtil.h"
//#import "RSADataSigner.h"

@implementation RequestMessage

-(instancetype) init{
    self = [super init];
    if (self) {
        //do something
    }
    return self;
}

- (instancetype)initWithUrl:(NSString *)url args:(NSMutableDictionary *)args{
    self = [super init];
    if (self) {
        _url=url;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]) {
            [args setObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"] forKey:@"accessToken"];
        }
        [args setObject:@"ios" forKey:@"deviceType"];
        [args setObject:[CommonUtil createUUID] forKey:@"deviceNo"];
        [args setObject:[CommonUtil getStringForDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"] forKey:@"request_time"];
//        [self signArgs:args];
        _args=args;
    }
    
    return self;
}

- (void)signArgs:(NSMutableDictionary *)args{
    NSArray* sortedKeyArray = [[args allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableArray *tmpArray = [NSMutableArray new];
    for (NSString* key in sortedKeyArray) {
        NSString* orderItem = [self orderItemWithKey:key andValue:[args objectForKey:key] encoded:NO];
        if (orderItem.length > 0) {
            [tmpArray addObject:orderItem];
        }
    }
//    NSString *orderInfo = [tmpArray componentsJoinedByString:@"&"];
//    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:(RSA_PRIVATE)];
//    NSString *signedString = [signer signString:orderInfo withRSA:NO];
//    [args setObject:signedString forKey:@"sign"];
    [args setObject:@"rsa" forKey:@"sign_method"];
    
}

//拼接格式
- (NSString*)orderItemWithKey:(NSString*)key andValue:(NSString*)value encoded:(BOOL)bEncoded
{
    if (key.length > 0 && value.length > 0) {
        
        return [NSString stringWithFormat:@"%@=%@", key, value];
    }
    return nil;
}

- (instancetype)initWithUrl:(NSString *)url method:(HttpMethod)method args:(NSDictionary *)args{
    self =[self initWithUrl:url args:args];
    _method=method;
    return self;
}

- (instancetype)initMutipartRequestWithUrl:(NSString *)url args:(NSDictionary *)args{
    self =[self initWithUrl:url args:args];
    _method=POST;
    _isMultipart=YES;
    return self;
}

@end
