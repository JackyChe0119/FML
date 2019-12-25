//
//  ReleaseTableViewCell.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ReleaseTableViewCell.h"
#import "DateUtil.h"

@implementation ReleaseTableViewCell {
    UILabel*    _username;
    UILabel*    _buyNum;
    UILabel*    _time;
    UILabel*    _releaseNum;
    UILabel*    _releaseDay;
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
        make.height.mas_equalTo(105);
    }];

    _username = [UILabel new];
    _username.text = @"用户名字";
    _username.textColor = Color1D;
    _username.font = [UIFont systemFontOfSize:15];
    [backgroundView addSubview:_username];
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(backgroundView).offset(20);
    }];
    
    _buyNum = [UILabel new];
    _buyNum.text = @"购买1000个";
    _buyNum.font = [UIFont systemFontOfSize:12];
    _buyNum.textColor = Color4D;
    [backgroundView addSubview:_buyNum];
    [_buyNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_username);
        make.top.equalTo(_username.mas_bottom).offset(7);
    }];
    
    _time = [UILabel new];
    _time.text = @"2018年7月15日";
    _time.font = [UIFont systemFontOfSize:12];
    _time.textColor = ColorGrayText;
    [backgroundView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buyNum);
        make.top.equalTo(_buyNum.mas_bottom).offset(15);
    }];
    
    _releaseNum = [UILabel new];
    _releaseNum.text = @"2344个";
    _releaseNum.font = [UIFont systemFontOfSize:14];
    _releaseNum.textColor = Color1D;
    [backgroundView addSubview:_releaseNum];
    [_releaseNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_username);
        make.right.equalTo(backgroundView).offset(-20);
    }];
    
    UILabel* releaseLB = [UILabel new];
    releaseLB.font = [UIFont systemFontOfSize:14];
    releaseLB.text = @"待释放";
    releaseLB.textColor = ColorGrayText;
    [backgroundView addSubview:releaseLB];
    [releaseLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_releaseNum);
        make.right.equalTo(_releaseNum.mas_left).offset(-10);
    }];
    
    _releaseDay = [UILabel new];
    _releaseDay.text = @"预计释放：60天";
    _releaseDay.font = [UIFont systemFontOfSize:12];
    _releaseDay.textColor = Color4D;
    [backgroundView addSubview:_releaseDay];
    [_releaseDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_releaseNum);
        make.top.equalTo(_buyNum);
    }];
}

- (void)setModel:(ReleaseListModel *)model {
    _model = model;
    _releaseDay.text = [NSString stringWithFormat:@"预计释放：%ld天", _model.dayNum];
    _releaseNum.text = [NSString stringWithFormat:@"%.2f个", _model.num];
    _buyNum.text = [NSString stringWithFormat:@"购买%.2f个", _model.buyNum];
    _username.text = _model.currencyType;
    _time.text = [DateUtil getDateStringFormString:[NSString stringWithFormat:@"%ld", _model.createTime / 1000] format:@"YYYY年M月d日"];
}
@end
