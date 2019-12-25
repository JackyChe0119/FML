//
//  UILabel+AutoSize.h
//  AutoSizeLabel
//
//  Created by 123 on 15/7/27.
//  Copyright (c) 2015年 Vision.Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TextAligment) {
    Left = 0,// 尚未申请发票
    Center,// 申请发票中
    Right,// 已完成申请发票
};

@interface UILabel (AutoSize)
//UILabel * labelRight = [[UILabel alloc] init];
//labelRight.textAlignment = NSTextAlignmentCenter;
//labelRight.bounds = CGRectMake(0, 0, 25, 11);
//labelRight.font = [UIFont systemFontOfSize:11];
//labelRight.center = CGPointMake(buttonRight.center.x, buttonRight.center.y + 18);
//labelRight.textColor = [UIColor colorWithHexString:COLORCUSTOM alpha:1];
//labelRight.text = @"分享";
//[view addSubview:labelRight];

- (void)autoSize;
- (void)autoWidthSize;
- (void)rect:(CGRect)rect center:(CGPoint)point aligment:(TextAligment)aligment font:(CGFloat)font isBold:(BOOL)isBold text:(NSString *)text textColor:(UIColor *)color superView:(UIView *)view;
- (void)rect:(CGRect)rect aligment:(TextAligment)aligment font:(CGFloat)font isBold:(BOOL)isBold text:(NSString *)text textColor:(UIColor *)color superView:(UIView *)view;
- (void)setParagraphText:(NSString*)text space:(NSInteger)space;
@end
