//
//  MaidTableViewCell.m
//  FML
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MaidTableViewCell.h"

@implementation MaidTableViewCell {
    
    __weak IBOutlet UILabel *_label1;
    __weak IBOutlet UILabel *_label2;
    __weak IBOutlet UILabel *_label3;
    __weak IBOutlet UILabel *_label4;
    __weak IBOutlet UILabel *_label5;
    __weak IBOutlet UILabel *_label6;
    
    __weak IBOutlet UILabel *_buyNum;
    __weak IBOutlet UILabel *_maidNum;
    __weak IBOutlet UILabel *_username;
    __weak IBOutlet UILabel *_buyNum2;
    __weak IBOutlet UILabel *_currencyName;
    __weak IBOutlet UILabel *_time;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _label1.textColor = colorWithHexString(@"#b8bbcc");
    _label2.textColor = Color1D;
    _label3.textColor = colorWithHexString(@"#b8bbcc");
    _label4.textColor = Color1D;
    _label5.textColor = colorWithHexString(@"#b8bbcc");
    _label6.textColor = colorWithHexString(@"#b8bbcc");
    _currencyName.textColor = colorWithHexString(@"#b8bbcc");
    
    _buyNum.textColor = Color1D;
    _username.textColor = Color4D;
    _maidNum.textColor = Color1D;
    _buyNum2.textColor = Color4D;
    _time.textColor = colorWithHexString(@"#828599");
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = ColorBg;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ReleaseListModel *)model {
    _model = model;
    _buyNum.text = [NSString stringWithFormat:@"%.2f", model.num];
    _maidNum.text = [NSString stringWithFormat:@"%.2f", model.lockNumber];
    _buyNum2.text = [NSString stringWithFormat:@"%.2f", model.buyNum];
    _time.text = [DateUtil getDateStringFormString:[NSString stringWithFormat:@"%ld", _model.createTime / 1000] format:@"YY-MM-dd"];
    _username.text = model.email;
    _currencyName.text = _model.currencyType;
}

@end
