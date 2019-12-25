//
//  UpLoadALiCloud.h
//  Wedding
//
//  Created by wangzhen on 16/1/26.
//  Copyright © 2016年 Bao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSSClient.h"
#import "OSSCompat.h"
typedef void (^SuccessBlock)(NSString * url);
typedef void (^FailBlock)(NSError * error);
typedef void(^FinishedBlock) (BOOL success, id response);
typedef void(^ProgressBlock) (CGFloat progress);
typedef void (^deleteBlock) (NSInteger tag) ;
@interface UpLoadALiCloud : NSObject
@property (nonatomic, strong) OSSClient * client;
@property (nonatomic, strong) OSSPutObjectRequest * put1;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) OSSGetObjectRequest *download;
@property (nonatomic, strong) deleteBlock deleteBlock;
- (void)initOSSClientWithEndPoint:(NSString *)endPoint URL:(NSString *)url;

//上传
- (void)startUpLoadWithData:(NSData *)data bucketName:(NSString *)bucket path:(NSString *)path suffix:(NSString *)suffix InView:(UIView *)photo withSuccessBlock:(SuccessBlock)successBlock FailBlock:(FailBlock)failBlock;
- (void)startUpLoadWithData:(NSData *)data bucketName:(NSString *)bucket path:(NSString *)path suffix:(NSString *)suffix suijishu:(NSString *)shuiji InView:(UIView *)photo withSuccessBlock:(SuccessBlock)successBlock FailBlock:(FailBlock)failBlock;
//下载

- (void)getDownlLoadHanderWithFilePath:(NSString *)filePath contentType:(NSString *)type progress:(ProgressBlock)progressBlock finished:(FinishedBlock)finishedBlock;


@end
