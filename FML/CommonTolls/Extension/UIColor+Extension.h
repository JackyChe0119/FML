//
//  UIColor+Extension.h
//  CCube
//
//  Created by Robin on 16/8/10.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexStringWithAlpha:(NSString*)hexString;
@end
