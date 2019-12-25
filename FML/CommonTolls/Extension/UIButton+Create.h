//
//  UIButton+Create.h
//  ManggeekPaySystem
//
//  Created by 车杰 on 2018/4/23.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Create)
+ (UIButton *)createimageButtonWithFrame:(CGRect)rect imageName:(NSString *)imageName;
+ (UIButton *)createCommonButtonWithFrame:(CGRect)rect title:(NSString *)title;
+ (UIButton *)createTextButtonWithFrame:(CGRect)rect bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor font:(CGFloat)font bold:(BOOL)bold title:(NSString *)title;
+ (UIButton *)creatJianBianButtonWithFrame:(CGRect)rect title:(NSString *)title;
@end
