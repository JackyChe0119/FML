//
//  UIButton+EdgeInset.m
//  Extension
//
//  Created by apple on 2018/7/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UIButton+EdgeInset.h"

@implementation UIButton (EdgeInset)

- (void)exchangeImageAndTitle {
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.imageView.frame.size.width, 0, self.imageView.frame.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.bounds.size.width, 0, -self.titleLabel.bounds.size.width)];
}

@end
