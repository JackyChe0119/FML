//
//  UIView+Create.m
//  H3CMagic
//
//  Created by mc on 15/12/14.
//  Copyright © 2015年 KongGeek. All rights reserved.
//

#import "UIView+Create.h"

@implementation UIView (Create)
+ (UIView *) createViewWithFrame:(CGRect)frame color:(UIColor *)color{
    
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}
+ (UIView *) createViewWithFrame:(CGRect)frame color:(UIColor *)color cornerRadius: (CGFloat)cornerRadius {
    UIView *view = [[UIView alloc]initWithFrame:frame];
    view.backgroundColor = color;
    view.layer.cornerRadius = cornerRadius;
    view.layer.masksToBounds = YES;
    return view;
}
//灰色线
+(UIView *)createLineViewWithFrame:(CGRect)frame{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    lineView.backgroundColor = colorWithHexString(@"#e6e6e6");
    return lineView;
}

@end
