//
//  touZiTopView.m
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "touZiTopView.h"

@implementation touZiTopView {
    UILabel *_priceLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =colorWithHexString(@"#f8f8f8");
        UIImageView *baseIamgeView = [UIImageView createImageViewWithFrame:RECT(5, 20, ScreenWidth-10, 120) imageName:@"icon_touzi_top"];
//        baseIamgeView.contentMode = 2;
        [self addSubview:baseIamgeView];
        
        UILabel *Label1 = [UILabel new];
        [Label1 rect:RECT(30, 50, ScreenWidth-120, 18) aligment:Left font:14 isBold:NO text:@"总资产" textColor:ColorWhite superView:self];
        
        [self addSubview:self.priceLabel];
        
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setImage:[UIImage imageNamed:@"icon_eyes"] forState:UIControlStateNormal];
        _selectBtn.center = CGPointMake(RIGHT(self.priceLabel) + 15, TOP(self.priceLabel) + 3);
        [_selectBtn sizeToFit];
        [self addSubview:_selectBtn];
        
        _lookBtn = [[UIButton alloc] initWithFrame:CGRectMake(RIGHT(self) - 100, HEIGHT(self) / 2 - 12.5, 60, 25)];
        _lookBtn.layer.borderWidth = 1;
        _lookBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _lookBtn.layer.cornerRadius = 4;
        _lookBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_lookBtn setTitle:@"查看" forState:UIControlStateNormal];
        [self addSubview:_lookBtn];
    }
    return self;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        [_priceLabel rect:RECT(30, 85, ScreenWidth-120, 25) aligment:Left font:22 isBold:YES text:@"¥ 8267.97" textColor:ColorWhite superView:self];
        [_priceLabel sizeToFit];
    }
    return _priceLabel;
}

- (void)setPriceStr:(NSString *)priceStr {
    _priceStr = priceStr;
    _priceLabel.text = _priceStr;
    [_priceLabel sizeToFit];
    _selectBtn.frame = CGRectMake(RIGHT(_selectBtn) + 15, TOP(self.priceLabel) + 3, 0, 0);
    [_selectBtn sizeToFit];
}
@end
