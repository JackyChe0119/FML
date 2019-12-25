//
//  AliyunOSSEngine.h
//  KongGeekSample
//
//  Created by Robin on 16/7/6.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkBlock.h"

@interface AliyunOSSEngine : NSObject

+ (void)uploadWithFilePath:(NSString *)filePath fileData:(NSData *)fileData progressBlock:(NetworkProgressCallback)progressBlock callbackBlock:(void (^)(NSString *fileUrl))callbackBlock;
@end
