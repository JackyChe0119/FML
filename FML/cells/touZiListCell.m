//
//  touZiListCell.m
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "touZiListCell.h"
#import "DateUtil.h"

@implementation touZiListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = colorWithHexString(@"#f8f8f8");

    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.leftImageView.layer.cornerRadius = 24;
    self.leftImageView.layer.masksToBounds = YES;
    
    self.titleLabel.textColor = Color1D;
    
    self.tag1.layer.cornerRadius = 3;
    self.tag1.layer.masksToBounds = YES;
    self.tag1.layer.borderWidth = .5;
    self.tag1.layer.borderColor = colorWithHexString(@"#7e9bc9").CGColor;
    self.tag1.textColor = colorWithHexString(@"7e9bc9");
    
    self.tag3.layer.cornerRadius = 3;
    self.tag3.layer.masksToBounds = YES;
    self.tag3.layer.borderWidth = .5;
    self.tag3.layer.borderColor = colorWithHexString(@"#7e9bc9").CGColor;
    self.tag3.textColor = colorWithHexString(@"#7e9bc9");
    
    self.dateLabel.textColor = Color4D;
    self.timeLabel.textColor = Color4D;
    self.openPriceLB.textColor = Color4D;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(InvestModel *)model {
    _model = model;

    [self.leftImageView sd_setImageWithURL:model.logo.toUrl];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ 1%@=%@", model.currenctyName,model.buyCurrencyName, model.ethRate];
    self.dateLabel.text = [DateUtil getDateStringFormString:model.createTime format:@"yyyy年M月d日"];
    _topRight.hidden = [model.isCochain isEqualToString:@"y"];
    _openPriceLB.text = [NSString stringWithFormat:@"市场价：≈%.2f usdt", model.currentPrice];
}

@end
