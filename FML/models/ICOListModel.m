//
//  ICOListModel.m
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ICOListModel.h"

@implementation ICOListModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        self.isShowTop = YES;
        self.isShowBottom = YES;
    }
    return self;
}

@end
