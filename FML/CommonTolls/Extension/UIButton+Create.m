//
//  UIButton+Create.m
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UIButton+Create.h"

@implementation UIButton (Create)
+ (UIButton *)createimageButtonWithFrame:(CGRect)rect imageName:(NSString *)imageName{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame  = rect;
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
    return button;
}
+ (UIButton *)creatJianBianButtonWithFrame:(CGRect)rect title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame  = rect;
    
    button.titleLabel.font = FONT(14);
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorWithHexString(@"#56a2fa").CGColor, (__bridge id)colorWithHexString(@"#5065f9").CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
   
    [button.layer addSublayer:gradientLayer];
    button.layer.cornerRadius = 3;
    button.layer.masksToBounds = YES;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}


+ (UIButton *)createTextButtonWithFrame:(CGRect)rect bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor font:(CGFloat)font bold:(BOOL)bold title:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = rect;
    
    [button setBackgroundColor:bgColor];
    
    [button setTitleColor:textColor forState:UIControlStateNormal];
    
    if (bold) {
        button.titleLabel.font = [UIFont boldSystemFontOfSize:font];
    }else {
        button.titleLabel.font = [UIFont systemFontOfSize:font];
    }
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}
+ (UIButton *)createCommonButtonWithFrame:(CGRect)rect title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 8.0;//2.0是圆角的弧度，根据需求自己更改
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.02, 0.36, 1.0, 1 });
    [button.layer setBorderColor:colorref];//边框颜色
    [button.layer setBorderWidth:0.5];
    button.frame  = rect;
    return button;
}
@end
