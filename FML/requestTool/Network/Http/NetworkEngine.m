//
//  NetworkEngine.m
//  KongGeekSample
//
//  Created by Robin on 16/7/5.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import "NetworkEngine.h"
#import "InterfaceMacro.h"
#import "AFHTTPSessionManager.h"
#import "JSONUtil.h"
#import "UUIDUtil.h"
#import "CommonToastHUD.h"
#define TIME_OUT 5 //请求超时时间

@implementation NetworkEngine

+(void)sendRequestMessage:(RequestMessage *)message delegate:(id)delegate callbackSelector:(SEL)callbackSelector{
    [self doRequest:message delegate:delegate callbackSelector:callbackSelector callbackBlock:nil];
}

+(void)sendRequestMessage:(RequestMessage *)message callbackBlock:(NetworkResponseCallback)callback{
    [self doRequest:message delegate:nil callbackSelector:nil callbackBlock:callback];
}

+(void)doRequest:(RequestMessage *)message delegate:(id)delegate callbackSelector:(SEL)callbackSelector callbackBlock:(NetworkResponseCallback)callbackBlock {
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (message.args) {
        [params setValuesForKeysWithDictionary:message.args];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = TIME_OUT;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    AFSecurityPolicy *security = [AFSecurityPolicy defaultPolicy];
    security.allowInvalidCertificates = YES;
    security.validatesDomainName = NO;
    manager.securityPolicy = security;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil];
//    [self addAdditionalParams:params];
 
//    NSString *jsonStr = [JSONUtil toJSONString:params];
    if (message.method==GET) {
        if ([message.url isEqualToString:@"https://openapi.idax.mn/api/v1/kline?pair=FML_ETH"]){
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setValue:params[@"period"] forKey:@"period"];
            params = dict;
        }
        [manager GET:message.url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"请求成功！responseObject : %@",responseObject);
            [self proccessResponse:message operation:responseObject responseObject:responseObject error:nil delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"请求出错:%@ + responseString : %@",error.userInfo,task);
            [self proccessResponse:message operation:error.userInfo responseObject:nil error:error delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
        }];
     }
    if (message.method==POST) {
        if (message.isMultipart) {
            [manager POST:message.url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [message.args enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([obj isKindOfClass:NSData.class]) {
                        [params removeObjectForKey:key];
                        NSString *fileName = [UUIDUtil generateUUID];
                    [formData appendPartWithFileData:obj name:key fileName:fileName mimeType:@"image/jpeg"];//文件名先用UUID，可替换
                    }
                }];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                     // 这里可以获取到目前的数据请求的进度
                 }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"请求成功！responseObject : %@",responseObject);
                [self proccessResponse:message operation:responseObject responseObject:responseObject error:nil delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"请求出错:%@ + responseString : %@",error.userInfo,task.response);
                [self proccessResponse:message operation:error.userInfo responseObject:nil error:error delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
            }];
        }else{
            [manager POST:message.url parameters:params  progress:^(NSProgress * _Nonnull uploadProgress) {
                // 这里可以获取到目前的数据请求的进度
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"请求成功！responseObject : %@",responseObject);
                [self proccessResponse:message operation:responseObject responseObject:responseObject error:nil delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"请求出错:%@ + responseString : %@",error.userInfo,task.response);
                [self proccessResponse:message operation:error.userInfo responseObject:nil error:error delegate:delegate callbackSelector:callbackSelector callbackBlock:callbackBlock];
            }];
        }
        message.url = [message.url stringByAppendingString:@"/?"];
        [[params allKeys] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx==0) {
                message.url = [message.url stringByAppendingString:[NSString stringWithFormat:@"%@=%@",obj,[params objectForKey:obj]]];
            }else {
                message.url = [message.url stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",obj,[params objectForKey:obj]]];
            }
        }];
        NSLog(@"============>>>>%@<<<<===========",message.url);
    }
}
+(void)proccessResponse:(RequestMessage *)message operation:(NSDictionary *)operation responseObject:(id)responseObject error:(NSError *)error delegate:(id)delegate callbackSelector:(SEL)callbackSelector callbackBlock:(NetworkResponseCallback)callbackBlock {
    ResponseMessage *responseMessage =[[ResponseMessage alloc] initWithRequestUrl:message.url requestArgs:message.args];
    if (responseObject && [responseObject isKindOfClass:NSDictionary.class]) {
        responseMessage.responseObject=responseObject;
        responseMessage.retCode=responseObject[@"retCode"];
        responseMessage.bussinessData=responseObject[@"data"];
        responseMessage.list = responseObject[@"list"];
        NSLog(@"=====%@======",responseMessage.bussinessData);
        responseMessage.errorMessage=responseObject[@"errorMsg"];
        responseMessage.totalPage = [responseObject[@"totalPage"] integerValue];
    }
    if ([responseMessage.retCode integerValue]==10002) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"]!=nil) {
            if ([APPInfoData shareData].appType==1) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"APPNeedLoginNotification" object:nil];
            }else {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"APPLoginOutNotification" object:nil];
            }
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"accessToken"];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您的账号登录已过期或在别处登录，如需继续操作请重新登录" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    if (error) {
        responseMessage.responseState=ResponseFailureFinished;
        responseMessage.retCode = @"500";//服务器异常
        if (error.code==-1009) {
            responseMessage.errorMessage = @"网络异常，请检查网络连接";
        }else if (error.code == -1001) {
            responseMessage.errorMessage = @"网络请求超时，请稍后重新尝试";
        }else {
            responseMessage.errorMessage = @"系统处理异常，请稍后重新尝试";
        }
    }else{
        responseMessage.responseState=ResponseSuccessFinished;
    }
    if (delegate && [delegate respondsToSelector:callbackSelector]) {
        //[delegate performSelector:callbackSelector withObject:respMsg];
        IMP imp = [delegate methodForSelector:callbackSelector];
        void (*func)(id, SEL,ResponseMessage *) = (void *)imp;
        func(delegate, callbackSelector,responseMessage);
    }
    if (callbackBlock) {
        if (!responseMessage.responseObject) {
            responseMessage.responseObject = responseObject;
        }
        callbackBlock(responseMessage);
    }
}

+(void)addAdditionalParams:(NSMutableDictionary *)params{
    NSString *accessToken =[[NSUserDefaults standardUserDefaults] objectForKey:ACCESS_TOKEN];
    if (accessToken) {
        [params setObject:accessToken forKey:ACCESS_TOKEN];
    }
    [params setObject:@"iOS" forKey:REQUEST_SOURCE];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [params setObject:version forKey:REQUEST_VERSION];
}

@end
