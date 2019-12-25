//
//  EarningListCell.m
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "EarningListCell.h"

@implementation EarningListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        self.gradientLayer.hidden = NO;
        self.nameLabel.hidden = NO;
        self.typeLabel.hidden = NO;
        self.priceLabel.hidden = NO;
        self.timeLabel.hidden = NO;
    }
    return self;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1.0, 0);
        _gradientLayer.frame = CGRectMake(20, 0, ScreenWidth-40, 50);
        _gradientLayer.cornerRadius = 3;
        [self.contentView.layer addSublayer:_gradientLayer];
    }
    return _gradientLayer;
}
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [_nameLabel rect:RECT(30, 10, (ScreenWidth-60)/3.0, 30) aligment:Left font:11 isBold:YES text:@"贡佳茜の空间站" textColor:[UIColor whiteColor] superView:self.contentView];
    }
    return _nameLabel;
}
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
        [_typeLabel rect:RECT(30+(ScreenWidth-60)/3.0, 10, (ScreenWidth-60)/3.0, 30) aligment:Center font:11 isBold:YES text:@"资产优选" textColor:[UIColor whiteColor] superView:self.contentView];
    }
    return _typeLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        [_priceLabel rect:RECT(30+(ScreenWidth-60)/3.0*2, 5, (ScreenWidth-60)/3.0, 20) aligment:Right font:14 isBold:YES text:@"+ 0.1008" textColor:colorWithHexString(@"#d4c81a") superView:self.contentView];
    }
    return _priceLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        [_timeLabel rect:RECT(30+(ScreenWidth-60)/3.0*2, 25, (ScreenWidth-60)/3.0, 20) aligment:Right font:8 isBold:YES text:@"2018.09.06" textColor:colorWithHexString(@"#635391") superView:self.contentView];
    }
    return _timeLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
