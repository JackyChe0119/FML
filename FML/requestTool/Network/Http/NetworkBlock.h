//
//  NetworkBlock.h
//  KongGeekSample
//
//  Created by Robin on 16/7/6.
//  Copyright © 2016年 KongGeek. All rights reserved.
//


#ifndef NetworkBlock_h
#define NetworkBlock_h

#import "ResponseMessage.h"

typedef void (^NetworkResponseCallback)(ResponseMessage *responseMessage);

typedef void (^NetworkProgressCallback)(long long bytesWritten,long long totalBytesWritten,long long totalBytesExpectedToWrite);

#endif /* NetworkBlock_h */
