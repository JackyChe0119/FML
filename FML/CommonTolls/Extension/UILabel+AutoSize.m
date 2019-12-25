 //
//  UILabel+AutoSize.m
//  AutoSizeLabel
//
//  Created by 123 on 15/7/27.
//  Copyright (c) 2015年 Vision.Wang. All rights reserved.
//

#import "UILabel+AutoSize.h"

@implementation UILabel (AutoSize)
- (void)autoSize
{
    self.numberOfLines = 0;
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
    //此处要使用ceil函数 大于或等于的最小整数
    //you must raise its value to the nearest higher integer using the ceil function.
    CGFloat height = ceil(CGRectGetHeight(rect));
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (void)autoWidthSize {
    self.numberOfLines = 1;
    CGRect rect = [self.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil];
    CGFloat width = ceil(CGRectGetWidth(rect));
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}
- (void)rect:(CGRect)rect center:(CGPoint)point aligment:(TextAligment)aligment font:(CGFloat)font isBold:(BOOL)isBold text:(NSString *)text textColor:(UIColor *)color superView:(UIView *)view
{
    self.frame = rect;
    self.center = point;
    switch (aligment)
    {
        case Left:
        {
            self.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case Center:
        {
            self.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case Right:
        {
            self.textAlignment = NSTextAlignmentRight;
        }
            break;
        default:
            break;
    }
    if (isBold)
    {
        self.font = [UIFont boldSystemFontOfSize:font];
    }
    else
    {
        self.font = [UIFont systemFontOfSize:font];
    }
    self.text = text;
    self.textColor = color;
    [view addSubview:self];
}
- (void)rect:(CGRect)rect aligment:(TextAligment)aligment font:(CGFloat)font isBold:(BOOL)isBold text:(NSString *)text textColor:(UIColor *)color superView:(UIView *)view
{
    self.frame = rect;
    switch (aligment)
    {
        case Left:
        {
            self.textAlignment = NSTextAlignmentLeft;
        }
            break;
        case Center:
        {
            self.textAlignment = NSTextAlignmentCenter;
        }
            break;
        case Right:
        {
            self.textAlignment = NSTextAlignmentRight;
        }
            break;
        default:
            break;
    }
    if (isBold)
    {
        self.font = [UIFont boldSystemFontOfSize:font];
    }
    else
    {
        self.font = [UIFont systemFontOfSize:font];
    }
    self.text = text;
    self.textColor = color;
    [view addSubview:self];
}
- (void)setParagraphText:(NSString*)text space:(NSInteger)space{
    if(text == nil || text.length == 0){
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    self.attributedText = attributedString;
}
@end
