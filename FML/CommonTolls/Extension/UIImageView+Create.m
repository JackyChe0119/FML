//
//  UIImageView+Create.m
//  KangDuKe
//
//  Created by xnj on 16/12/12.
//  Copyright © 2016年 MJ Science and Technology Ltd. All rights reserved.
//

#import "UIImageView+Create.h"

@implementation UIImageView (Create)
+ (UIImageView *) createImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    imageView.image = image;
    return imageView;
}
@end
