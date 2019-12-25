//
//  APPInfoData.h
//  ManggeekBaseProject
//
//  Created by 车杰 on 2017/12/26.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPInfoData : NSObject
@property (nonatomic,assign)NSInteger appType;//1 强制登录类型  2非强制登录类型
+(instancetype)shareData;
@end
