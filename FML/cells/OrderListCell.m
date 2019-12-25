//
//  OrderListCell.m
//  FML
//
//  Created by 车杰 on 2018/8/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = ColorBg;
    self.nameLabel.textColor = Color4D;
    self.priceLabel.textColor = Color4D;
    self.timeLabel.textColor = colorWithHexString(@"#b8bbcc");
    self.statusLabel.textColor = ColorRed;
}
- (void)showCellWithModel:(OrderListModel *)model {
    self.nameLabel.text = model.targetNickName;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2fCNY",[model.price doubleValue]];
    self.timeLabel.text = [DateUtil getDateStringFormString:model.createTime format:@"yyyy-MM-dd HH:mm"];
    if ([model.type isEqualToString:@"buy"]) {
        if (model.status==0) {
            self.statusLabel.text = @"待付款";
            self.statusLabel.textColor = ColorRed;
        }else if (model.status==1) {
            self.statusLabel.text = @"待确认";
            self.statusLabel.textColor = ColorRed;
        }else if (model.status==2) {
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = ColorGreen;
        }else {
            self.statusLabel.text = @"已失效";
            self.statusLabel.textColor = colorWithHexString(@"#b8bbcc");
        }
    }else {
        if (model.status==0) {
             self.statusLabel.text = @"待放行";
            self.statusLabel.textColor = ColorRed;
        }else if (model.status==1) {
            self.statusLabel.text = @"待放行";
            self.statusLabel.textColor = ColorRed;
        }else if (model.status==2) {
            self.statusLabel.text = @"已完成";
            self.statusLabel.textColor = ColorGreen;
        }else {
            self.statusLabel.text = @"已失效";
            self.statusLabel.textColor = colorWithHexString(@"#b8bbcc");
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
