//
//  InterfaceMarco.h
//  KongGeekSample
//
//  Created by Robin on 16/7/2.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#ifndef InterfaceMarco_h
#define InterfaceMarco_h

#define URLAppendAPIServer(path) [NSString stringWithFormat:@"%@%@",URL_RootAPIServer,path]

#define ACCESS_TOKEN @"accessToken"
#define REQUEST_VERSION  @"version"
#define REQUEST_SOURCE @"source"

//测试环境
#define URL_RootAPIServer @"http://apifml.manggeek.com/"
//#define ALIYUN_OSS_BUCKET_NAME @"konggeek-img"
//#define ALIYUN_OSS_ACCESS_DOMAIN @"http://img-cdn.konggeek.com"

//正式环境
//#define URL_RootAPIServer @"http://api.c-cubic.com"
#define ALIYUN_OSS_BUCKET_NAME @"walletdlp"
#define ALIYUN_OSS_IMAGE_DOMAIN @"http://walletdlp.oss-cn-hongkong.aliyuncs.com/"


#define ALIYUN_OSS_SERVER @"http://oss-cn-hongkong.aliyuncs.com"
#define ALIYUN_OSS_GET_ACCESS_TOKEN @"common/alioss/distribute_token.htm"


#endif /* InterfaceMarco_h */
