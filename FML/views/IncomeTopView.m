//
//  IncomeTopView.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "IncomeTopView.h"

@implementation IncomeTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    UIImageView *baseIamgeView = [UIImageView createImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, 80 + StatusBarHeight + 44) imageName:@"touzi_top"];
    baseIamgeView.backgroundColor = [UIColor blueColor];
    [self addSubview:baseIamgeView];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:backUp_wihte];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [self addSubview:_leftButton];
    
    _titleLabel = [UILabel new];
    [_titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:19 isBold:YES text:@"" textColor:[UIColor whiteColor] superView:self];
    
    _currencyIcon = [UIImageView createImageViewWithFrame:CGRectMake(20, BOTTOM(_leftButton) + 15, 40, 40) imageName:@""];
    _currencyIcon.backgroundColor = [UIColor clearColor];
    _currencyIcon.layer.cornerRadius = 20;
    _currencyIcon.layer.masksToBounds = YES;
    [self addSubview:_currencyIcon];
    
    _currencyName = [[UILabel alloc] initWithFrame:CGRectMake(RIGHT(_currencyIcon) + 15, TOP(_currencyIcon), 100, 40)];
    _currencyName.backgroundColor = [UIColor clearColor];
    _currencyName.text = @"";
    _currencyName.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    _currencyName.textColor = [UIColor whiteColor];
    [self addSubview:_currencyName];
    
    self.frame = CGRectMake(0, 0, ScreenWidth, 80 + StatusBarHeight + 44);
    
    _currencyNum = [[UILabel alloc] initWithFrame:CGRectMake(_currencyName.right, TOP(_currencyIcon), ScreenWidth - _currencyName.right - 15, 40)];
    _currencyNum.text = @"数量0个";
    _currencyNum.textAlignment = NSTextAlignmentRight;
    _currencyNum.textColor = [UIColor whiteColor];
    [self addSubview:_currencyNum];
}

@end
