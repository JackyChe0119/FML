//
//  UpLoadALiCloud.m
//  Wedding
//
//  Created by wangzhen on 16/1/26.
//  Copyright © 2016年 Bao. All rights reserved.
//

#import "UpLoadALiCloud.h"
//#import "CommonUtil.h"
@implementation UpLoadALiCloud
// endPoint http://oss-cn-hangzhou.aliyuncs.com
- (void)initOSSClientWithEndPoint:(NSString *)endPoint URL:(NSString *)url {
    NSString * checkTimeStamp = [[NSUserDefaults standardUserDefaults] valueForKey:@"checkTimeStamp"];
    NSString * currentTimeStamp = [self obtainCurrentTimeStamp];
    id<OSSCredentialProvider> credential2;
    if (checkTimeStamp == (NSString *)nil || ([currentTimeStamp integerValue] - [checkTimeStamp integerValue] > 1800)) {
        credential2 = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
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
    
    self.client = [[OSSClient alloc] initWithEndpoint:endPoint credentialProvider:credential2 clientConfiguration:conf];

}

/**
 *	@brief	获取当前的时间戳
 */
- (NSString *)obtainCurrentTimeStamp {
    NSDate * date = [NSDate date];
    long currentDate = [date timeIntervalSince1970];
    NSString * currentTimeStamp = [NSString stringWithFormat:@"%ld",currentDate];
    return currentTimeStamp;
}


- (void)startUpLoadWithData:(NSData *)data bucketName:(NSString *)bucket path:(NSString *)path suffix:(NSString *)suffix InView:(UIView *)photo withSuccessBlock:(SuccessBlock)successBlock FailBlock:(FailBlock)failBlock {
    self.put1 = [OSSPutObjectRequest new];
    self.put1.bucketName = bucket;
    NSString * radomUUID1 = @"manggeekCrt";
    NSString * date = [DateUtil getStringFromDate:[NSDate date] format:@"yyyyMMddHHmmss"];
    self.put1.objectKey = [NSString stringWithFormat:@"%@/%@%@.%@",path,radomUUID1,date,suffix];
    self.put1.uploadingData = data;
    
    if (photo != nil) {
        UIView * shadow = [[UIView alloc] init];
        shadow.frame = photo.bounds;
        shadow.backgroundColor = [UIColor blackColor];
        shadow.alpha = 0.6;
        [photo addSubview:shadow];
        //显示上传百分比
        UILabel * labelProgress = [[UILabel alloc] init];
        labelProgress.frame = CGRectMake(0, 0, photo.frame.size.width, 15);
        labelProgress.textAlignment = NSTextAlignmentCenter;
        labelProgress.textColor = [UIColor whiteColor];
        labelProgress.font = [UIFont systemFontOfSize:14];
        [shadow addSubview:labelProgress];
        labelProgress.center = shadow.center;
        
        //关闭按钮
        
        
        
        __block typeof (self) WeakSelf = self;
        self.put1.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            dispatch_async(dispatch_get_main_queue(), ^{
                labelProgress.text = [NSString stringWithFormat:@"%.0f%@",(totalByteSent / (totalBytesExpectedToSend / 1.0)) * 100,@"%"];
                if (totalByteSent / totalBytesExpectedToSend == 1) {
                    [shadow removeFromSuperview];
                    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    cancleButton.frame = CGRectMake(shadow.frame.size.width -25, -25, 50, 50);
                    [cancleButton setImage:[UIImage imageNamed:@"xxxxxx"] forState:UIControlStateNormal];
                    [cancleButton addTarget:WeakSelf action:@selector(clickCancle:) forControlEvents:UIControlEventTouchUpInside];
                    photo.userInteractionEnabled = YES;
                    [photo addSubview:cancleButton];
                }
            });
        };
    }
    
    OSSTask * putTask1 = [self.client putObject:self.put1];
    [putTask1 continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"图片1上传成功");
            successBlock(self.put1.objectKey);
        } else {
            [self click:photo];
            NSLog(@"upload object failed, error: %@", task.error);
             failBlock(task.error);
        }
        return nil;
    }];
    if (!putTask1.faulted) {
        
    } else {
       
    }

}
- (void)startUpLoadWithData:(NSData *)data bucketName:(NSString *)bucket path:(NSString *)path suffix:(NSString *)suffix suijishu:(NSString *)shuiji InView:(UIView *)photo withSuccessBlock:(SuccessBlock)successBlock FailBlock:(FailBlock)failBlock  {
    self.put1 = [OSSPutObjectRequest new];
    self.put1.bucketName = bucket;
    NSString * radomUUID1 = @"manggeekCrt";
    NSString * date = [DateUtil getStringFromDate:[NSDate date] format:@"yyyyMMddHHmmss"];
    self.put1.objectKey = [NSString stringWithFormat:@"%@/%@%@%@.%@",path,radomUUID1,shuiji,date,suffix];
    self.put1.uploadingData = data;
    
    if (photo != nil) {
        UIView * shadow = [[UIView alloc] init];
        shadow.frame = photo.bounds;
        shadow.backgroundColor = [UIColor blackColor];
        shadow.alpha = 0.6;
        [photo addSubview:shadow];
        //显示上传百分比
        UILabel * labelProgress = [[UILabel alloc] init];
        labelProgress.frame = CGRectMake(0, 0, photo.frame.size.width, 15);
        labelProgress.textAlignment = NSTextAlignmentCenter;
        labelProgress.textColor = [UIColor whiteColor];
        labelProgress.font = [UIFont systemFontOfSize:14];
        [shadow addSubview:labelProgress];
        labelProgress.center = shadow.center;
        
        //关闭按钮
        __block typeof (self) WeakSelf = self;
        self.put1.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
            dispatch_async(dispatch_get_main_queue(), ^{
                labelProgress.text = [NSString stringWithFormat:@"%.0f%@",(totalByteSent / (totalBytesExpectedToSend / 1.0)) * 100,@"%"];
                if (totalByteSent / totalBytesExpectedToSend == 1) {
                    [shadow removeFromSuperview];
                    UIButton * cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    cancleButton.frame = CGRectMake(shadow.frame.size.width -25, -25, 50, 50);
                    [cancleButton setImage:[UIImage imageNamed:@"xxxxxx"] forState:UIControlStateNormal];
                    [cancleButton addTarget:WeakSelf action:@selector(clickCancle:) forControlEvents:UIControlEventTouchUpInside];
                    photo.userInteractionEnabled = YES;
                    [photo addSubview:cancleButton];
                }
            });
        };
    }
    
    OSSTask * putTask1 = [self.client putObject:self.put1];
    [putTask1 continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"图片1上传成功");
            successBlock(self.put1.objectKey);
        } else {
            [self click:photo];
            NSLog(@"upload object failed, error: %@", task.error);
            failBlock(task.error);
        }
        return nil;
    }];
    if (!putTask1.faulted) {
        
    } else {
        
    }
}
//下载资源
- (void)getDownlLoadHanderWithFilePath:(NSString *)filePath contentType:(NSString *)type progress:(ProgressBlock)progressBlock finished:(FinishedBlock)finishedBlock {
    [self initOSSClientWithEndPoint:@"http://oss-cn-shanghai.aliyuncs.com" URL:@"http://api.chuanchuan.zhangwukeji.com/common/alioss/distribute_token.htm"];
    //首先监测删除资源是否在OSS上
//    NSString* oss_path=DS_GET(@"userid");
//    NSString* key=[NSString stringWithFormat:@"%@/%@",oss_path,filePath];
    NSError *error = nil;
//    BOOL isExist = [_client doesObjectExistInBucket:@"chuanchuan" objectKey:key error:&error];
//    if (!error) {
//        if (isExist) {
//            //文件存在
//            NSLog(@"The file you want to delete does exist!");
//        } else {
//            //文件不存在
//            NSLog(@"The file you want to delete doesnot exist!");
//            return;
//        }
//    } else {
//        //发生错误
//        NSLog(@"Error happens:%@", error);
//        return;
//    }
    
    self.download = [OSSGetObjectRequest new];
    self.download.bucketName = @"chuanchuan";
    if (filePath) {
        self.download.objectKey = [filePath substringFromIndex:35];
    }
    self.download.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        progressBlock(totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
        
    };
    OSSTask *task = [_client getObject:self.download];
    [task continueWithBlock:^id(OSSTask *task) {
        if (task.error) {
            //发生错误
            NSLog(@"Error happens:%@", error);
            finishedBlock(NO, task.error);
        } else {
            OSSGetObjectResult * getResult = task.result;
            
            finishedBlock(YES, getResult.downloadedData);
        }
        return nil;
    }];
}


/**
 *	@brief	点击取消上传
 */
- (void)clickCancle:(UIButton *)button {
//    [button removeFromSuperview];
//    NSInteger tag = button.superview.tag;
//    [button.superview removeFromSuperview];
//    [button.superview.superview removeFromSuperview];
//    if (_deleteBlock) {
//        _deleteBlock (tag);
//    }
}
- (void)click:(UIView *)view {
//    NSInteger tag = view.tag;
//    [view removeFromSuperview];
//    if (_deleteBlock) {
//        _deleteBlock (tag);
//    }
}

@end
