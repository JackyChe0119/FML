//
//  MyBranchTableViewCell.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MyBranchTableViewCell.h"

@implementation MyBranchTableViewCell {
    UIImageView*    _currencyIcon;
    UILabel*        _currencyName;
    UILabel*        _currencyNum;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setView];
    }
    return self;
}

- (void)setView {
    UIView* contentView = self.contentView;
    contentView.backgroundColor = RGB_A(248, 248, 248, 1);
    
    UIImageView* backgroundView = [UIImageView new];
    backgroundView.image = [UIImage imageNamed:@"layer"];
    [contentView addSubview:backgroundView];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(contentView).offset(10);
        make.right.equalTo(contentView).offset(-10);
        make.bottom.equalTo(contentView);
        make.height.mas_equalTo(110);
    }];
    
    _currencyIcon = [UIImageView new];
    _currencyIcon.backgroundColor = [UIColor clearColor];
    _currencyIcon.layer.masksToBounds = YES;
    _currencyIcon.layer.cornerRadius = 22.5;
    [backgroundView addSubview:_currencyIcon];
    [_currencyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backgroundView).offset(20);
        make.width.height.mas_equalTo(45);
    }];
    
    _currencyName = [UILabel new];
    _currencyName.text = @"ETH";
    _currencyName.textColor = Color1D;
    _currencyName.font = [UIFont systemFontOfSize:18];
    [backgroundView addSubview:_currencyName];
    [_currencyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_currencyIcon.mas_right).offset(10);
        make.centerY.equalTo(_currencyIcon);
    }];
    
    _currencyNum = [UILabel new];
    _currencyNum.text = @"2000个";
    _currencyNum.textColor = Color1D;
    _currencyNum.font = [UIFont systemFontOfSize:18];
    [backgroundView addSubview:_currencyNum];
    [_currencyNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(backgroundView).offset(-20);
        make.centerY.equalTo(_currencyIcon);
    }];
    
    UIButton* gotoDatail = [UIButton buttonWithType:UIButtonTypeCustom];
    [gotoDatail setTitle:@"查看详情" forState:UIControlStateNormal];
    [gotoDatail setTitleColor:Color4D forState:UIControlStateNormal];
    gotoDatail.titleLabel.font = [UIFont systemFontOfSize:15];
    [backgroundView addSubview:gotoDatail];
    [gotoDatail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backgroundView.mas_bottom).offset(-10);
        make.centerX.equalTo(backgroundView);
    }];
    
    UIImageView* imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_accesstype3"]];
    [self addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(gotoDatail);
        make.left.equalTo(gotoDatail.mas_right).offset(5);
    }];
    
    UIImageView* imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_accesstype3"]];
    [self addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(gotoDatail);
        make.left.equalTo(imageView1.mas_right).offset(1);
    }];
}

- (void)setModel:(MyBranchListModel *)model {
    _model = model;
    _currencyNum.text = [NSString stringWithFormat:@"%.2f个", model.lockCommissNumber];
    _currencyName.text = model.currencyName;
    [_currencyIcon sd_setImageWithURL:model.logo.toUrl];
}

@end
