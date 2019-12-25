//
//  FMLListCell.m
//  FML
//
//  Created by 车杰 on 2018/9/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "FMLListCell.h"

@implementation FMLListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = ColorBg;
        self.baseView.hidden = NO;
        self.lineView.hidden = NO;
        self.label1.hidden = NO;
        self.label2.hidden = NO;
        self.label3.hidden = NO;
        self.label4.hidden = NO;
        self.label5.hidden = NO;
        self.label6.hidden = NO;
        self.label7.hidden = NO;
        self.label8.hidden = NO;
    }
    return self;
}
- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 120) color:[UIColor whiteColor]];
        [self.contentView addSubview:_baseView];
    }
    return _baseView;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView createViewWithFrame:RECT(20, 60, ScreenWidth-40, .5) color:ColorLine];
        [self.baseView addSubview:_lineView];
    }
    return _lineView;
}
- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [UILabel new];
        [_label1 rect:RECT(20, 10, (ScreenWidth-40)/2.0, 20) aligment:Left font:10 isBold:YES text:@"发起币种" textColor:colorWithHexString(@"#c8c8c8") superView:self.baseView];
        _label1.adjustsFontSizeToFitWidth = YES;
    }
    return _label1;
}
- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [UILabel new];
        [_label2 rect:RECT(20, 30, (ScreenWidth-40)/2.0, 20) aligment:Left font:13 isBold:YES text:@"2000.00" textColor:colorWithHexString(@"#646464") superView:self.baseView];
        _label2.adjustsFontSizeToFitWidth = YES;
    }
    return _label2;
}
- (UILabel *)label3 {
    if (!_label3) {
        _label3 = [UILabel new];
        [_label3 rect:RECT(ScreenWidth/2.0, 10, (ScreenWidth-40)/2.0, 20) aligment:Right font:10 isBold:YES text:@"交易对" textColor:colorWithHexString(@"#c8c8c8") superView:self.baseView];        _label3.adjustsFontSizeToFitWidth = YES;

    }
    return _label3;
}
- (UILabel *)label4 {
    if (!_label4) {
        _label4 = [UILabel new];
        [_label4 rect:RECT(ScreenWidth/2.0, 30, (ScreenWidth-40)/2.0, 20) aligment:Right font:13 isBold:YES text:@"22.00" textColor:colorWithHexString(@"#646464") superView:self.baseView];        _label4.adjustsFontSizeToFitWidth = YES;

    }
    return _label4;
}
- (UILabel *)label5 {
    if (!_label5) {
        _label5 = [UILabel new];
        [_label5 rect:RECT(20, 70, (ScreenWidth-40)/2.0, 20) aligment:Left font:10 isBold:YES text:@"获得币种" textColor:colorWithHexString(@"#c8c8c8") superView:self.baseView];
        _label5.adjustsFontSizeToFitWidth = YES;
    }
    return _label5;
}
- (UILabel *)label6 {
    if (!_label6) {
        _label6 = [UILabel new];
        [_label6 rect:RECT(20, 90, (ScreenWidth-40)/2.0, 20) aligment:Left font:13 isBold:YES text:@"2000.00" textColor:colorWithHexString(@"#646464") superView:self.baseView];
        _label6.adjustsFontSizeToFitWidth = YES;

    }
    return _label6;
}
- (UILabel *)label7 {
    if (!_label7) {
        _label7 = [UILabel new];
        [_label7 rect:RECT(ScreenWidth/2.0, 70, (ScreenWidth-40)/2.0, 20) aligment:Right font:10 isBold:YES text:@"交易时间" textColor:colorWithHexString(@"#c8c8c8") superView:self.baseView];
        _label7.adjustsFontSizeToFitWidth = YES;

    }
    return _label7;
}
- (UILabel *)label8 {
    if (!_label8) {
        _label8 = [UILabel new];
        [_label8 rect:RECT(ScreenWidth/2.0, 90, (ScreenWidth-40)/2.0, 20) aligment:Right font:13 isBold:YES text:@"22.00" textColor:colorWithHexString(@"#646464") superView:self.baseView];
        _label8.adjustsFontSizeToFitWidth = YES;
    }
    return _label8;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
