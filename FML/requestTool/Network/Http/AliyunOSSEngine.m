//
//  AliyunOSSEngine.m
//  KongGeekSample
//
//  Created by Robin on 16/7/6.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "AliyunOSSEngine.h"
#import "OSSService.h"
#import "OSSCompat.h"
#import "UUIDUtil.h"
#import "InterfaceMacro.h"

@implementation AliyunOSSEngine

+(void) uploadWithFilePath:(NSString *)filePath fileData:(NSData *)fileData progressBlock:(NetworkProgressCallback)progressBlock callbackBlock:(void (^)(NSString *fileUrl))callbackBlock{
    OSSClient *ossClient = [self initOSSClient];
    OSSPutObjectRequest *putRequest = [OSSPutObjectRequest new];
    putRequest.uploadProgress=^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
        if (progressBlock) {
            progressBlock(bytesSent,totalBytesSent,totalBytesExpectedToSend);
        }
    };
    putRequest.bucketName = ALIYUN_OSS_BUCKET_NAME;
    //    NSString * radomUUID1 = [methodUtil createUUID];
    //    NSString * date = [DateUtil getStringFromDate:[NSDate date] format:@"yyyy/MM/dd"];
    putRequest.objectKey = filePath;
    putRequest.uploadingData = fileData;
    OSSTask * putTask = [ossClient putObject:putRequest];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSString *fileUrl = filePath;
            NSLog(@"上传阿里云成功，fileUrl：%@",fileUrl);
            callbackBlock(fileUrl);
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"checkTimeStamp"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSLog(@"上传阿里云失败, error: %@" , task.error);
            callbackBlock(nil);
        }
        return nil;
    }];
}

//OSS 初始化client
+ (OSSClient *)initOSSClient {
    NSString * const endPoint = ALIYUN_OSS_SERVER;
    NSString * checkTimeStamp = [[NSUserDefaults standardUserDefaults] valueForKey:@"checkTimeStamp"];
    NSString * currentTimeStamp = [self obtainCurrentTimeStamp];
    id<OSSCredentialProvider> credential2;
    if (!checkTimeStamp || [currentTimeStamp integerValue] - [checkTimeStamp integerValue] > 1800) {
        credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
            NSString * accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:ACCESS_TOKEN];
            NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?accessToken=%@",ALIYUN_OSS_GET_ACCESS_TOKEN,accessToken]];
            NSURLRequest * request = [NSURLRequest requestWithURL:url];
            OSSTaskCompletionSource * tcs = [OSSTaskCompletionSource taskCompletionSource];
            NSURLSession * session = [NSURLSession sharedSession];
            NSURLSessionTask * sessionTask = [session dataTaskWithRequest:request
                                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                            if (error) {
                                                                [tcs setError:error];
                                                                return;
                                                            }
                                                            [tcs setResult:data];
                                                        }];
            [sessionTask resume];
            [tcs.task waitUntilFinished];
            if (tcs.task.error) {
                NSLog(@"get token error: %@", tcs.task.error);
                return nil;
            } else {
                NSDictionary * object = [NSJSONSerialization JSONObjectWithData:tcs.task.result
                                                                        options:kNilOptions
                                                                          error:nil];
                OSSFederationToken * token = [OSSFederationToken new];
                NSDictionary * data = [object objectForKey:@"data"];
                token.tAccessKey = [data objectForKey:@"accessKeyId"];
                token.tSecretKey = [data objectForKey:@"accessKeySecret"];
                token.tToken = [data objectForKey:@"securityToken"];
                token.expirationTimeInGMTFormat = [data objectForKey:@"expiration"];
                NSLog(@"get token: %@", token);
                
                // 存入本地 获取当前的时间戳 做半个小时的校验
                [[NSUserDefaults standardUserDefaults] setValue:token.tAccessKey forKey:@"accessKeyId"];
                [[NSUserDefaults standardUserDefaults] setValue:token.tSecretKey forKey:@"accessKeySecret"];
                [[NSUserDefaults standardUserDefaults] setValue:token.tToken forKey:@"securityToken"];
                [[NSUserDefaults standardUserDefaults] setValue:token.expirationTimeInGMTFormat forKey:@"expiration"];
                
                // 存时间戳
                NSString * checkStamp = [self obtainCurrentTimeStamp];
                [[NSUserDefaults standardUserDefaults] setValue:checkStamp forKey:@"checkTimeStamp"];
                return token;
            }
        }];
        
    } else {
        credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken *{
            OSSFederationToken * token = [OSSFederationToken new];
            token.tAccessKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessKeyId"];
            token.tSecretKey = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessKeySecret"];
            token.tToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"securityToken"];
            token.expirationTimeInGMTFormat = [[NSUserDefaults standardUserDefaults] valueForKey:@"expiration"];
            return token;
        }];
    }
    
    OSSClientConfiguration * conf = [OSSClientConfiguration new];
    conf.maxRetryCount = 2;
    conf.timeoutIntervalForRequest = 30;
    conf.timeoutIntervalForResource = 24 * 60 * 60;
    return [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential2 clientConfiguration:conf];
}

/**
 *    @brief    获取当前的时间戳
 */
+ (NSString *)obtainCurrentTimeStamp {
    NSDate * date = [NSDate date];
    long currentDate = [date timeIntervalSince1970];
    NSString * currentTimeStamp = [NSString stringWithFormat:@"%ld",currentDate];
    return currentTimeStamp;
}
//@end
@end

