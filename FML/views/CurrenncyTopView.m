//
//  CurrenncyTopView.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CurrenncyTopView.h"


@interface CurrenncyTopView()

@property (nonatomic, strong) UIImageView*  baseIamgeView;

@end

@implementation CurrenncyTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    UIImageView *baseIamgeView = [UIImageView createImageViewWithFrame:CGRectMake(0, 0, ScreenWidth, 175 + StatusBarHeight + 44) imageName:@"touzi_top"];
    baseIamgeView.backgroundColor = [UIColor blueColor];
    [self addSubview:baseIamgeView];
    _baseIamgeView = baseIamgeView;
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:backUp_wihte];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [self addSubview:_leftButton];
    
    _titleLabel = [UILabel new];
    [_titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:19 isBold:YES text:@"" textColor:[UIColor whiteColor] superView:self];
    
    _currencyIcon = [UIImageView createImageViewWithFrame:CGRectMake(20, BOTTOM(_leftButton) + 25, 40, 40) imageName:@""];
//    _currencyIcon.backgroundColor = [UIColor orangeColor];
    _currencyIcon.layer.cornerRadius = 20;
    _currencyIcon.layer.masksToBounds = YES;
    [self addSubview:_currencyIcon];
    
    _currencyName = [[UILabel alloc] initWithFrame:CGRectMake(RIGHT(_currencyIcon) + 15, TOP(_currencyIcon), 150, 40)];
    _currencyName.backgroundColor = [UIColor clearColor];
    _currencyName.text = @"";
    _currencyName.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];
    _currencyName.textColor = [UIColor whiteColor];
    [self addSubview:_currencyName];
    
    self.frame = CGRectMake(0, 0, ScreenWidth, 175 + StatusBarHeight + 44);
    
    _currencyNum = [[UILabel alloc] initWithFrame:CGRectMake(self.right - 250, TOP(_currencyIcon), 230, 100)];
    _currencyNum.text = @"";
    _currencyNum.textColor = [UIColor whiteColor];
    _currencyNum.numberOfLines = 0;
    _currencyNum.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
    _currencyNum.textAlignment = NSTextAlignmentRight;
    [self addSubview:_currencyNum];
//    [self changeLineSpaceForLabel:_currencyNum WithSpace:10];


    [self setMidView];
}


- (void)setMidView {
    
    _item1 = [[CurrencyItem alloc] initWithFrame:CGRectMake(0, BOTTOM(_currencyNum) + 35, ScreenWidth / 2, 20)];
    _item2 = [[CurrencyItem alloc] initWithFrame:CGRectMake(ScreenWidth / 2 + 10, BOTTOM(_currencyNum) + 35, ScreenWidth / 2, 20)];
    _item3 = [[CurrencyItem alloc] initWithFrame:CGRectMake(0, BOTTOM(_item1) + 5, ScreenWidth / 2, 20)];
    _item4 = [[CurrencyItem alloc] initWithFrame:CGRectMake(ScreenWidth / 2 + 10, BOTTOM(_item1) + 5, ScreenWidth / 2, 20)];
    
    [self addSubview:_item1];
    [self addSubview:_item2];
    [self addSubview:_item3];
    [self addSubview:_item4];
    
    _item1.leftStr = @"总发行量";
    _item2.leftStr = @"流通市值";
    _item3.leftStr = @"交易量";
    _item4.leftStr = @"24h成交量";
    
    _item1.rightStr = @"0";
    _item2.rightStr = @"0";
    _item3.rightStr = @"0";
    _item4.rightStr = @"0";
    
    self.frame = CGRectMake(0, 0, ScreenWidth, BOTTOM(_item4) + 15);
    _baseIamgeView.frame = CGRectMake(0, 0, ScreenWidth, BOTTOM(_item4) + 15);
}

- (void)setRightStr:(NSString *)rightStr {
    _rightStr = rightStr;
    _currencyNum.text = _rightStr;
    [self changeLineSpaceForLabel:_currencyNum WithSpace:10];
}

- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {

    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.alignment = NSTextAlignmentRight;
    NSDictionary * dic =@{NSParagraphStyleAttributeName:paragraphStyle, NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone] };
    [attributedString setAttributes:dic range:NSMakeRange(0, attributedString.length)];
    label.attributedText = attributedString;
    [label sizeToFit];
    label.frame = CGRectMake(RIGHT(self) - WIDTH(label) - 20, TOP(label), WIDTH(label), HEIGHT(label));
}


@end
