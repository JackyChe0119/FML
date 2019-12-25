//
//  InterstellarListCell.m
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "InterstellarListCell.h"

@implementation InterstellarListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.gradientLayer.hidden = NO;
        [self.contentView addSubview:self.iconImageView];
        self.bitLabel.hidden = NO;
        self.numberLabel.hidden = NO;
        self.bitLabel.hidden  = NO;
        self.priceLabel.hidden = NO;
        [self.contentView addSubview:self.accetypeIamgeview];
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
- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView createImageViewWithFrame:RECT(30, 12, 26, 26) imageName:@""];
        _iconImageView.layer.cornerRadius = 13;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}
- (UIImageView *)accetypeIamgeview {
    if (!_accetypeIamgeview) {
        _accetypeIamgeview = [UIImageView createImageViewWithFrame:RECT(ScreenWidth-40, 12, 12, 26) imageName:@"icon_accesstype_star"];
        _accetypeIamgeview.contentMode = UIViewContentModeCenter;
    }
    return _accetypeIamgeview;
}
- (UILabel *)bitLabel {
    if (!_bitLabel) {
        _bitLabel = [UILabel new];
        [_bitLabel rect:RECT(70,10,70,30) aligment:Left font:12 isBold:YES text:@"BTC" textColor:colorWithHexString(@"#ffffff") superView:self.contentView];
    }
    return _bitLabel;
}
//- (UILabel *)numberLabel {
//    if (!_numberLabel) {
//        _numberLabel = [UILabel new];
//        [_numberLabel rect:RECT(70,25,70, 15) aligment:Left font:10 isBold:YES text:@"20个节点" textColor:colorWithHexString(@"#b2b2bd") superView:self.contentView];
//    }
//    return _numberLabel;
//}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
           [_priceLabel rect:RECT(130,15,ScreenWidth-180, 20) aligment:Right font:12 isBold:YES text:@"219.9080" textColor:[UIColor whiteColor] superView:self.contentView];
    }
    return _priceLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
