//
//  ICOOrderTableViewCell.m
//  FML
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ICOOrderTableViewCell.h"
#import "DateUtil.h"

@implementation ICOOrderTableViewCell{
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
    UIView* backgroundView = self.contentView;
    
    _username = [UILabel new];
    _username.text = @"用户名字";
    _username.textColor = Color1D;
    _username.font = [UIFont systemFontOfSize:18];
    [backgroundView addSubview:_username];
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backgroundView).offset(10);
        make.left.equalTo(backgroundView).offset(20);
    }];
    
    _buyNum = [UILabel new];
    _buyNum.text = @"购买1000个";
    _buyNum.font = [UIFont systemFontOfSize:14];
    _buyNum.textColor = Color4D;
    [backgroundView addSubview:_buyNum];
    [_buyNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_username);
        make.top.equalTo(_username.mas_bottom).offset(5);
    }];
    
    _time = [UILabel new];
    _time.text = @"2018年7月15日";
    _time.font = [UIFont systemFontOfSize:12];
    _time.textColor = ColorGrayText;
    [backgroundView addSubview:_time];
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_buyNum);
        make.top.equalTo(_buyNum.mas_bottom).offset(10);
    }];
    
    _releaseDay = [UILabel new];
    _releaseDay.text = @"预计释放：60天";
    _releaseDay.font = [UIFont systemFontOfSize:14];
    _releaseDay.textColor = ColorGreen;
    [backgroundView addSubview:_releaseDay];
    [_releaseDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_username);
        make.right.equalTo(backgroundView).offset(-20);
    }];
}

- (void)setModel:(ICOListModel *)model {
    _model = model;
    _username.text = model.currencyName;
    _time.text = [DateUtil getDateStringFormString:[NSString stringWithFormat:@"%lu", model.createTime/1000] format:@"YYYY年M月d日"];
    _buyNum.text = [NSString stringWithFormat:@"购买%.2f个", model.total];
    if ([model.status isEqualToString:@"wait"]) {
        _releaseDay.textColor = ColorRed;
        _releaseDay.text = @"待确认";
    }else if ([model.status isEqualToString:@"lock"]) {
        _releaseDay.textColor = ColorRed;
        _releaseDay.text = @"锁定中";
    }else if ([model.status isEqualToString:@"release"]) {
        _releaseDay.textColor = colorWithHexString(@"#999999");
        _releaseDay.text = @"已释放";
    }else {
        _releaseDay.textColor = colorWithHexString(@"#999999");
        _releaseDay.text = @"未释放";
    }
}

@end
