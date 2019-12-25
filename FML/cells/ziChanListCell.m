//
//  ziChanListCell.m
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ziChanListCell.h"

@implementation ziChanListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = colorWithHexString(@"#f8f8f8");
    self.precentLabel.textColor = ColorWhite;
    self.titleLabel.textColor = Color1D;
    self.topNumLabel.textColor = Color1D;
    self.bottonPriceLabel.textColor = colorWithHexString(@"4d5066");
    self.leftImageView.layer.cornerRadius = 18;
    self.leftImageView.layer.masksToBounds = YES;
    self.baseView.backgroundColor = colorWithHexString(@"#f8f8f8");
//    self.titleLabel_Width.constant = ScreenWidth/2.0-115;
    self.precentLabel.adjustsFontSizeToFitWidth = YES;
    self.topNumLabel.adjustsFontSizeToFitWidth = YES;
    self.lockNumber.textColor = Color4D;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(WalletListModel *)model {
    _model = model;
    [_leftImageView sd_setImageWithURL:model.logo.toUrl];
    _titleLabel.text = model.currenctName;
    
//    if (model.increase < 0) {
//        _precentLabel.text = [NSString stringWithFormat:@"%.2f%%", -model.increase];
//        _precentLabel.backgroundColor = ColorRed;
//        _statusLabel.image = [UIImage imageNamed:@"icon_xiahua.png"];
//        _statusLabel.backgroundColor = ColorRed;
//    } else {
//        _precentLabel.text = [NSString stringWithFormat:@"%.2f%%", model.increase];
//        _precentLabel.backgroundColor = ColorGreen;
//        _statusLabel.image = [UIImage imageNamed:@"iocn_shangsheng.png"];
//        _statusLabel.backgroundColor = ColorGreen;
//    }
//
    self.precentLabel.hidden = YES;
    self.statusLabel.hidden = YES; 
    
    _topNumLabel.text = [NSString stringWithFormat:@"%.2f", model.number];
    _bottonPriceLabel.text = [NSString stringWithFormat:@"%.2f usdt", model.price];
    if (model.freezeNumber > 0.00001) {
        _lockNumber.text = [NSString stringWithFormat:@"锁定中：%.2f个", model.freezeNumber];
        _lockNumber.hidden = NO;
        self.top.constant = 26;
    } else {
        self.top.constant = 38;
        _lockNumber.hidden = YES;
        _lockNumber.text = model.currenctName;
    }
}

@end
