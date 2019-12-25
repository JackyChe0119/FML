//
//  SonNodeListCell.m
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "SonNodeListCell.h"

@implementation SonNodeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.gradientLayer.hidden = NO;
        self.nameLabel.hidden = NO;
        self.typeLabel.hidden = NO;
        [self.contentView addSubview:self.iconImageView];
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
        _iconImageView.backgroundColor = [UIColor whiteColor];
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
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        [_nameLabel rect:RECT(70, 10, 80, 30) aligment:Left font:11 isBold:YES text:@"贡佳茜の空间站" textColor:[UIColor whiteColor] superView:self.contentView];
    }
    return _nameLabel;
}
- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [UILabel new];
        [_typeLabel rect:RECT(160, 10,ScreenWidth-210, 30) aligment:Right font:11 isBold:YES text:@"" textColor:[UIColor whiteColor] superView:self.contentView];
    }
    return _typeLabel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
