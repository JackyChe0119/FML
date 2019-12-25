//
//  APPInfoData.m
//  ManggeekBaseProject
//
//  Created by 车杰 on 2017/12/26.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import "APPInfoData.h"

@implementation APPInfoData
static id _data = nil;
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (!_data) {
            _data = [super allocWithZone:zone];
        }
    }
    return _data;
}
+ (instancetype)shareData {
    @synchronized(self) {
        if (!_data) {
            _data = [[self alloc]init];
        }
    }
    return _data;
}
-(id)copyWithZone:(struct _NSZone *)zone{
    return _data;
}
    @end
