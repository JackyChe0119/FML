//
//  TransactionTableViewCell.m
//  XjBaseProject
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import "TransactionTableViewCell.h"
#import "DateUtil.h"

@interface TransactionTableViewCell()

@property (nonatomic, strong) UIImageView*  usericon;
@property (nonatomic, strong) UILabel*      username;
@property (nonatomic, strong) UILabel*      price;
@property (nonatomic, strong) UILabel*      time;
@property (nonatomic, strong) UILabel*      percent;

@end

@implementation TransactionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    
    _usericon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
//    _usericon.layer.masksToBounds = YES;
//
//    _usericon.layer.cornerRadius = 20;
    _usericon.backgroundColor = [UIColor clearColor];
    _usericon.hidden = YES;
    [self.contentView addSubview:_usericon];
    
    _username = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, 200, 18)];
    _username.text = @"";
    _username.backgroundColor = [UIColor whiteColor];
    _username.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_username];
    
    _price = [[UILabel alloc] initWithFrame:CGRectMake(25, BOTTOM(_usericon) - 16, 200, 10)];
//    _price.text = @"交易价格：0.00 usdt";
    _price.font = [UIFont systemFontOfSize:14];
    _price.backgroundColor = [UIColor whiteColor];
//    [self.contentView addSubview:_price];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(25, BOTTOM(_username) + 18, 200, 14)];
    _time.font = [UIFont systemFontOfSize:14];
    _time.textColor = [UIColor grayColor];
    _time.text = @"00-00  00:00";
    _time.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_time];
    
    _percent = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 150, 15, 135, 30)];
    _percent.text = @"0.00";
    _percent.textAlignment = NSTextAlignmentRight;
    _percent.textColor = [UIColor redColor];
    _percent.font = [UIFont systemFontOfSize:16];
    _percent.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_percent];
}

- (void)setModel:(FlowListModel *)model {
    _model = model;
    NSString* str = model.title;
    _username.text = str;
    _time.text = [DateUtil getDateStringFormString:String(model.createTime) format:@"MM-dd  H:mm"];
//    _price.text = [NSString stringWithFormat:@"交易价格：≈ %.2f usdt", model.price];
    if ([model.operation isEqualToString:@"-"]) {
        _percent.textColor = ColorRed;
        _percent.text = [NSString stringWithFormat:@"-%.2f", model.num];
    } else {
        _percent.textColor = ColorGreen;
        _percent.text = [NSString stringWithFormat:@"%.2f", model.num];
    }
}

- (void)setRecordModel:(RecordIncomeModel *)recordModel {
    _recordModel = recordModel;
    _username.text = [NSString stringWithFormat:@"%.2f %@", recordModel.num, recordModel.currencyType];
    _time.text = [DateUtil getDateStringFormString:[NSString stringWithFormat:@"%ld", (long)recordModel.createTime] format:@"MM-dd  H:mm"];
    
    if (recordModel.status == 1) {
        _percent.text = @"充值成功";
        _percent.textColor = ColorGreen;
    }else if (recordModel.status==-1) {
        _percent.text = @"校验中";
        _percent.textColor = ColorRed;
    } else {
        _percent.text = @"校验中";
        _percent.textColor = ColorRed;
    }
}

- (void)setRecordgetModel:(RecordGetModel *)recordgetModel {
    _recordgetModel = recordgetModel;
    _username.text = [NSString stringWithFormat:@"%.2f %@", _recordgetModel.num, _recordgetModel.type];
    _time.text = [DateUtil getDateStringFormString:[NSString stringWithFormat:@"%ld", (long)_recordgetModel.createTime] format:@"MM-dd  H:mm"];
    
    if (_recordgetModel.status == 1) {
        _percent.text = @"提现成功";
        _percent.textColor = ColorGreen;
    } else if (_recordgetModel.status == 0) {
        _percent.text = @"校验中";
        _percent.textColor = ColorRed;
    } else if (_recordgetModel.status == -1) {
        _percent.text = @"取消";
        _percent.textColor = ColorRed;
    } else if (_recordgetModel.status == -2) {
        _percent.text = @"拒绝提现";
        _percent.textColor = ColorRed;
    }
}

- (NSDictionary *)dict {
    return @{
             @"sbuy"        :   @"购买",
             @"sale"        :   @"出售",
             @"income"      :   @"转入",
             @"out"         :   @"提现",
             @"commission"  :   @"佣金",
             @"tocash"    :   @"提现",
             @"release"     :   @"释放",
             @"buy"         :   @"投资",
             @"recharge"    :   @"充值"
             };
}
@end
