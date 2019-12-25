//
//  QuantizationCell.m
//  FML
//
//  Created by 车杰 on 2018/9/4.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "QuantizationCell.h"

@implementation QuantizationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.ContentTitleLabel.hidden = NO;
        self.label1.hidden = NO;
        self.label2.hidden = NO;
        self.label3.hidden = NO;
        self.label4.hidden = NO;
        self.label5.hidden = NO;
        self.label6.hidden = NO;
        self.label7.hidden = NO;
        self.label8.hidden = NO;
        self.label9.hidden = NO;
        self.label10.hidden = NO;
        self.label11.hidden = NO;
        self.label12.hidden = NO;
        self.lineView1.hidden = NO;
        self.lineView2.hidden = NO;
        self.lineView3.hidden = NO;
        [self.contentView addSubview:self.tixiButton];
        [self.contentView addSubview:self.redemptionButton];
    }
    return self;
}
- (void)showCellWithDic:(NSDictionary *)result {
    self.ContentTitleLabel.text = [NSString stringWithFormat:@"%@(%@)",result[@"fundTitle"],result[@"payType"]];
    self.label7.text = [NSString stringWithFormat:@"%.2f%%",[result[@"profitRate"] doubleValue]*100*12];
    self.label8.text = [NSString stringWithFormat:@"%.2f%@",[result[@"amount"] doubleValue],result[@"payType"]];
    self.label9.text =  [NSString stringWithFormat:@"%.2f%@",[result[@"expectProfit"] doubleValue],result[@"payType"]];
    self.label10.text =  [NSString stringWithFormat:@"%ldDAY",[result[@"duration"] integerValue]];
    self.label11.text = [DateUtil getDateStringFormString:result[@"createTime"] format:@"yyyy.MM.dd"];
    self.label12.text = [DateUtil getDateStringFormString:result[@"endTime"] format:@"yyyy.MM.dd"];
    self.isFocus = NO;
    if ([result[@"status"] integerValue]==1) {
        if ([result[@"income"] doubleValue]>0) {
            self.tixiButton.hidden = NO;
            self.redemptionButton.hidden = NO;
            [self.tixiButton setTitle:@"提息" forState:UIControlStateNormal];
            [self.redemptionButton setTitle:@"强制赎回" forState:UIControlStateNormal];
            self.ContentTipLabel.text = @"月息已结算,可提息";
            _redemptionButton.frame = RECT(ScreenWidth-145, 15, 55, 21);
        }else {
            self.tixiButton.hidden = YES;
            self.ContentTipLabel.text = @"收益中...";
            self.redemptionButton.hidden = NO;
            [self.tixiButton setTitle:@"强制赎回" forState:UIControlStateNormal];
            _redemptionButton.frame = RECT(ScreenWidth-80, 15, 55, 21);
            self.isFocus = YES;
        }
    }else if ([result[@"status"] integerValue]==2) {
        [self.tixiButton setTitle:@"赎回" forState:UIControlStateNormal];
        self.redemptionButton.hidden = YES;
        self.tixiButton.hidden = NO;
        self.ContentTipLabel.text = @"投资期限已到,可赎回";
    }else if ([result[@"status"] integerValue]==3) {
        self.tixiButton.hidden = YES;
        self.redemptionButton.hidden = YES;
        self.ContentTipLabel.text = @"量化订单赎回中";
    }else if ([result[@"status"] integerValue]==4) {
        self.tixiButton.hidden = YES;
        self.redemptionButton.hidden = YES;
        self.ContentTipLabel.text = @"量化订单已赎回";
    }else {
        self.tixiButton.hidden = YES;
        self.redemptionButton.hidden = YES;
        self.ContentTipLabel.text = @"量化订单待确认中";
    }
 
}
- (UIButton *)tixiButton {
    if (!_tixiButton) {
        _tixiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _tixiButton.frame = RECT(ScreenWidth-80, 14, 60, 28);
        [_tixiButton setTitle:@"提息" forState:UIControlStateNormal];
        [_tixiButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
        [_tixiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _tixiButton.titleLabel.font = FONT(10);
        [_tixiButton setBackgroundImage:IMAGE(@"iocn_btn_bg") forState:UIControlStateNormal];
        [_tixiButton addTarget:self action:@selector(tixiButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tixiButton;
}
- (UIButton *)redemptionButton {
    if (!_redemptionButton) {
        _redemptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _redemptionButton.frame = RECT(ScreenWidth-145, 15, 55, 21);
        [_redemptionButton setTitle:@"赎回" forState:UIControlStateNormal];
        [_redemptionButton setTitleColor:Color4D forState:UIControlStateNormal];
        _redemptionButton.titleLabel.font = FONT(10);
        [_redemptionButton setBackgroundColor:[UIColor whiteColor]];
        _redemptionButton.layer.cornerRadius = 1;
        _redemptionButton.layer.masksToBounds = YES;
        _redemptionButton.layer.borderWidth = .5;
        _redemptionButton.layer.borderColor = Color4D.CGColor;
        [_redemptionButton addTarget:self action:@selector(_redemptionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redemptionButton;
}
- (void)tixiButtonClick:(UIButton *)sender{
    if (_operationBlock) {
        if ([sender.titleLabel.text isEqualToString:@"提息"]) {
            _operationBlock(1);
        }else {
            _operationBlock(2);
        }
    }
}
- (void)_redemptionButtonClick:(UIButton *)sender {
    if (_operationBlock) {
        _operationBlock(3);
    }
}
- (UILabel *)ContentTitleLabel {
    if (!_ContentTitleLabel) {
        _ContentTitleLabel = [UILabel new];
        [_ContentTitleLabel rect:RECT(20, 10, ScreenWidth-170, 22) aligment:Left font:14 isBold:YES text:@"币风港湾 第一期(ETH)" textColor:colorWithHexString(@"#7d7d7d") superView:self.contentView];
    }
    return _ContentTitleLabel;
}
- (UILabel *)ContentTipLabel {
    if (!_ContentTipLabel) {
        _ContentTipLabel = [UILabel new];
        [_ContentTipLabel rect:RECT(20, 32, ScreenWidth-100, 14) aligment:Left font:10 isBold:NO text:@"" textColor:colorWithHexString(@"#7d7d7d") superView:self.contentView];
    }
    return _ContentTipLabel;
}
- (UILabel *)label1 {
    if (!_label1) {
        _label1 = [UILabel new];
        [_label1 rect:RECT(20, 65, (ScreenWidth-40)/3.0, 20) aligment:Left font:10 isBold:YES text:@"预期年化" textColor:colorWithHexString(@"#c8c8c8") superView:self.contentView];
    }
    return _label1;
}
- (UILabel *)label7 {
    if (!_label7) {
        _label7 = [UILabel new];
        [_label7 rect:RECT(20, 65+20, (ScreenWidth-40)/3.0, 20) aligment:Left font:12 isBold:YES text:@"1201.00%" textColor:colorWithHexString(@"#646464") superView:self.contentView];
    }
    return _label7;
}
- (UILabel *)label2 {
    if (!_label2) {
        _label2 = [UILabel new];
        [_label2 rect:RECT(20+(ScreenWidth-40)/3.0, 65, (ScreenWidth-40)/3.0, 20) aligment:Center font:10 isBold:YES text:@"认购数量" textColor:colorWithHexString(@"#c8c8c8") superView:self.contentView];
    }
    return _label2;
}
- (UILabel *)label8 {
    if (!_label8) {
        _label8 = [UILabel new];
        [_label8 rect:RECT(20+(ScreenWidth-40)/3.0, 65+20, (ScreenWidth-40)/3.0, 20) aligment:Center font:12 isBold:YES text:@"100.000BTC" textColor:colorWithHexString(@"#646464") superView:self.contentView];
    }
    return _label8;
}
- (UILabel *)label3 {
    if (!_label3 ) {
        _label3 = [UILabel new];
        [_label3 rect:RECT(20+(ScreenWidth-40)/3.0*2, 65, (ScreenWidth-40)/3.0, 20) aligment:Right font:10 isBold:YES text:@"预期收益" textColor:colorWithHexString(@"#c8c8c8") superView:self.contentView];
    }
    return _label3;
}
- (UILabel *)label9 {
    if (!_label9) {
        _label9 = [UILabel new];
        [_label9 rect:RECT(20+(ScreenWidth-40)/3.0*2, 65+20, (ScreenWidth-40)/3.0, 20) aligment:Right font:12 isBold:YES text:@"100.000BTC" textColor:colorWithHexString(@"#646464") superView:self.contentView];
    }
    return _label9;
}
- (UILabel *)label4 {
    if (!_label4) {
        _label4 = [UILabel new];
        [_label4 rect:RECT(20, 65+70, (ScreenWidth-40)/3.0, 20) aligment:Left font:10 isBold:YES text:@"认购期限" textColor:colorWithHexString(@"#c8c8c8") superView:self.contentView];
    }
    return _label4;
}
- (UILabel *)label10 {
    if (!_label10) {
        _label10 = [UILabel new];
        [_label10 rect:RECT(20, 65+20+70, (ScreenWidth-40)/3.0, 20) aligment:Left font:12 isBold:YES text:@"360DAY" textColor:colorWithHexString(@"#646464") superView:self.contentView];
    }
    return _label10;
}

- (UILabel *)label5 {
    if (!_label5) {
        _label5 = [UILabel new];
        [_label5 rect:RECT(20+(ScreenWidth-40)/3.0, 65+70, (ScreenWidth-40)/3.0, 20) aligment:Center font:10 isBold:YES text:@"认购日期" textColor:colorWithHexString(@"#c8c8c8") superView:self.contentView];
    }
    return _label5;
}
- (UILabel *)label11 {
    if (!_label11) {
        _label11 = [UILabel new];
        [_label11 rect:RECT(20+(ScreenWidth-40)/3.0, 65+20+70, (ScreenWidth-40)/3.0, 20) aligment:Center font:12 isBold:YES text:@"2018-10-10" textColor:colorWithHexString(@"#646464") superView:self.contentView];
    }
    return _label11;
}

- (UILabel *)label6 {
    if (!_label6 ) {
        _label6 = [UILabel new];
        [_label6 rect:RECT(20+(ScreenWidth-40)/3.0*2, 65+70, (ScreenWidth-40)/3.0, 20) aligment:Right font:10 isBold:YES text:@"到期日期" textColor:colorWithHexString(@"#c8c8c8") superView:self.contentView];
    }
    return _label6;
}
- (UILabel *)label12 {
    if (!_label12) {
        _label12 = [UILabel new];
        [_label12 rect:RECT(20+(ScreenWidth-40)/3.0*2, 65+20+70, (ScreenWidth-40)/3.0, 20) aligment:Right font:12 isBold:YES text:@"2018-10-10" textColor:colorWithHexString(@"#646464") superView:self.contentView];
    }
    return _label12;
}
- (UIView *)lineView1 {
    if (!_lineView1) {
        _lineView1 = [UIView createViewWithFrame:RECT(20, 50, ScreenWidth-40, .5) color:colorWithHexString(@"#f8f8f8")];
        [self.contentView addSubview:_lineView1];
    }
    return _lineView1;
}
- (UIView *)lineView2 {
    if (!_lineView2) {
        _lineView2 = [UIView createViewWithFrame:RECT(20, 50+70, ScreenWidth-40, .5) color:colorWithHexString(@"#f8f8f8")];
        [self.contentView addSubview:_lineView2];
    }
    return _lineView2;
}
- (UIView *)lineView3 {
    if (!_lineView3) {
        _lineView3 = [UIView createViewWithFrame:RECT(00, 190, ScreenWidth, 10) color:colorWithHexString(@"#f8f8f8")];
        [self.contentView addSubview:_lineView3];
    }
    return _lineView3;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
