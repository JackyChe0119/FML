//
//  NetworkEngine.h
//  KongGeekSample
//
//  Created by Robin on 16/7/5.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkBlock.h"
#import "RequestMessage.h"
#import "ResponseMessage.h"

@interface NetworkEngine : NSObject

+(void)sendRequestMessage:(RequestMessage *)message delegate:(id)delegate callbackSelector:(SEL)callbackSelector;

+(void)sendRequestMessage:(RequestMessage *)message callbackBlock:(NetworkResponseCallback)callbackBlock;

@end
