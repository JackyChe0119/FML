//
//  UILabel+usdt.m
//  FML
//
//  Created by apple on 2018/8/13.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UILabel+usdt.h"
#import "SwizzlingDefine.h"
#import "ZMChineseConvert.h"

@implementation UILabel (usdt)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod(self, @selector(setText:), @selector(fml_setText:));
    });
}

- (void)fml_setText:(NSString *)text {
    if (![text containsString:@"≈"] && [text containsString:@"usdt"] && ![text isEqualToString:@"0 usdt"] && (text.length > 5)) {
        text = [@"≈" stringByAppendingString:text];
    }
    text = [ZMChineseConvert convertSimplifiedToTraditional:text];
    [self fml_setText:text];
}

@end
