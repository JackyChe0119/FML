//
//  RequestEngine.m
//  CCube
//
//  Created by Robin on 16/8/20.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "RequestEngine.h"

@implementation RequestEngine

/*
 ***  数据请求类 ****
 */
+ (void)doRqquestWithMessage:(RequestMessage *)message callbackBlock:(NetworkResponseCallback)callbackBlock {
    [NetworkEngine sendRequestMessage:message callbackBlock:^(ResponseMessage *responseMessage) {
        callbackBlock(responseMessage);
    }];
}
@end
