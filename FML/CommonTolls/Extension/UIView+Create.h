//
//  UIView+Create.h
//  H3CMagic
//
//  Created by mc on 15/12/14.
//  Copyright © 2015年 KongGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Create)
+ (UIView *) createViewWithFrame:(CGRect)frame color:(UIColor *)color;
+ (UIView *) createViewWithFrame:(CGRect)frame color:(UIColor *)color cornerRadius: (CGFloat)cornerRadius;
//灰色线
+(UIView *)createLineViewWithFrame:(CGRect)frame;
@end
