//
//  QuantizationListCell.m
//  FML
//
//  Created by 车杰 on 2018/9/5.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "QuantizationListCell.h"

@implementation QuantizationListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = ColorBg;
        self.selectionStyle = 0;
//        [self addSubview:self.bgView];
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.typeButton];
        self.ContentTitleLabel.hidden = NO;
        self.label1.hidden = NO;
        self.label2.hidden = NO;
        self.label3.hidden = NO;
        self.label4.hidden = NO;
        self.label5.hidden = NO;
        self.label6.hidden = NO;
        self.lineView1.hidden = NO;
    }
    return self;
}
- (void)showCellWithDic:(NSDictionary *)result {
    
    if (result[@"label"]!=nil) {
        [self.typeButton setBackgroundImage:IMAGE(@"icon_button_bg2") forState:UIControlStateNormal];
        [self.typeButton setTitle:result[@"label"] forState:UIControlStateNormal];
    }else {
        [self.typeButton setImage:IMAGE(@"") forState:UIControlStateNormal];
        self.typeButton.hidden = YES;
    }
    self.ContentTitleLabel.text = [NSString stringWithFormat:@"%@(%@)",result[@"title"],result[@"currencyType"]];
    self.label4.text = [NSString stringWithFormat:@"%.2f%%",[result[@"profitRate"] doubleValue]*100*12];
    self.label5.text = [NSString stringWithFormat:@"%.2f%@",[result[@"minAmount"] doubleValue],result[@"currencyType"]];
    self.label6.text = [NSString stringWithFormat:@"%ldDAY",[result[@"duration"] integerValue]];
}
- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [UIImageView createImageViewWithFrame:RECT(15, 0, ScreenWidth-30, 110) imageName:@"layer"];
    }
    return _bgView;
}
- (UILabel *)ContentTitleLabel {
    if (!_ContentTitleLabel) {
        _ContentTitleLabel = [UILabel new];
        [_ContentTitleLabel rect:RECT(15, 10, ScreenWidth-120, 30) aligment:Left font:14 isBold:YES text:@"币风港湾 第一期(ETH)" textColor:colorWithHexString(@"#7d7d7d") superView:self.bgView];
    }
    return _ContentTitleLabel;
}
- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [UILabel new];
        [_label1 rect:RECT(15, 60, (ScreenWidth-60)/3.0, 20) aligment:Left font:10 isBold:YES text:@"预期年化" textColor:colorWithHexString(@"#c8c8c8") superView:self.bgView];
    }
    return _label1;
}
- (UILabel *)label4 {
    if (!_label4) {
        _label4 = [UILabel new];
        [_label4 rect:RECT(15, 60+20, (ScreenWidth-60)/3.0, 20) aligment:Left font:12 isBold:YES text:@"120.00%" textColor:[UIColor redColor] superView:self.bgView];
    }
    return _label4;
}


- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [UILabel new];
        [_label2 rect:RECT(15+(ScreenWidth-60)/3.0, 60, (ScreenWidth-60)/3.0, 20) aligment:Center font:10 isBold:YES text:@"起购数量" textColor:colorWithHexString(@"#c8c8c8") superView:self.bgView];
    }
    return _label2;
}
- (UILabel *)label5 {
    if (!_label5) {
        _label5 = [UILabel new];
        [_label5 rect:RECT(15+(ScreenWidth-60)/3.0, 60+20, (ScreenWidth-60)/3.0, 20) aligment:Center font:12 isBold:YES text:@"100.000BTC" textColor:colorWithHexString(@"#646464") superView:self.bgView];
    }
    return _label5;
}

- (UILabel *)label3 {
    if (!_label3 ) {
        _label3 = [UILabel new];
        [_label3 rect:RECT(15+(ScreenWidth-60)/3.0*2, 60, (ScreenWidth-60)/3.0, 20) aligment:Right font:10 isBold:YES text:@"认购期限" textColor:colorWithHexString(@"#c8c8c8") superView:self.bgView];
    }
    return _label3;
}
- (UILabel *)label6 {
    if (!_label6) {
        _label6 = [UILabel new];
        [_label6 rect:RECT(15+(ScreenWidth-60)/3.0*2, 60+20, (ScreenWidth-60)/3.0, 20) aligment:Right font:12 isBold:YES text:@"100.000BTC" textColor:colorWithHexString(@"#646464") superView:self.bgView];
    }
    return _label6;
}
- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [UIView createViewWithFrame:RECT(15, 50, ScreenWidth-40, .5) color:colorWithHexString(@"#f8f8f8")];
        [self.bgView addSubview:_lineView1];
    }
    return _lineView1;
}
- (UIButton *)typeButton {
    if (!_typeButton) {
        _typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _typeButton.frame = RECT(ScreenWidth-100, 14, 60, 28);
        [_typeButton setTitle:@"新手专享" forState:UIControlStateNormal];
        [_typeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
        [_typeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _typeButton.titleLabel.font = FONT(10);
        [_typeButton setBackgroundImage:IMAGE(@"iocn_btn_bg") forState:UIControlStateNormal];
    }
    return _typeButton;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

@end
