//
//  UILabel+ft.m
//  FML
//
//  Created by apple on 2018/8/13.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UILabel+ft.h"
#import "SwizzlingDefine.h"

#define kLableFont @""

@implementation UILabel (ft)

+(void)load {
    //只执行一次这个方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod([self class], @selector(init), @selector(myInit));
        swizzling_exchangeMethod([self class], @selector(initWithFrame:), @selector(myInitWithFrame:));
        swizzling_exchangeMethod([self class], @selector(awakeFromNib), @selector(myAwakeFromNib));
    });
}

- (instancetype)myInit {
    id __self = [self myInit];
    if (self.text.length > 0) {
        self.text = self.text;
    }
    return __self;
}

- (instancetype)myInitWithFrame:(CGRect)rect {
    id __self = [self myInitWithFrame: rect];
    if (self.text.length > 0) {
        self.text = self.text;
    }
    return __self;
}

- (void)myAwakeFromNib {
    [self myAwakeFromNib];
    if (self.text.length > 0) {
        self.text = self.text;
    }
}



@end
