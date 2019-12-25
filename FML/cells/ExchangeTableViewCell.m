//
//  ExchangeTableViewCell.m
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ExchangeTableViewCell.h"

@implementation ExchangeTableViewCell {
    
//    __weak IBOutlet UILabel *label1;
//    __weak IBOutlet UILabel *label2;
    __weak IBOutlet UILabel *label3;
    __weak IBOutlet UILabel *label4;
    __weak IBOutlet UIButton *btn;
    __weak IBOutlet UIView *leftView;
    
//    __weak IBOutlet UIImageView *_icon;
    __weak IBOutlet UILabel *_username;
    __weak IBOutlet UILabel *_price;
    __weak IBOutlet UILabel *_canBuy;
    __weak IBOutlet UILabel *haveETH;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    btn.backgroundColor = ColorBlue;
    btn.layer.cornerRadius = 4;
    
   
    label3.textColor = label4.textColor = ColorGrayText;
    _username.textColor = _price.textColor = Color1D;
    _canBuy.textColor = haveETH.textColor = Color4D;
    
//    _icon.layer.cornerRadius = 19.5;
//    _icon.layer.masksToBounds = YES;
//
    leftView.backgroundColor = ColorBlue;
    
    self.backgroundColor = ColorBg;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setType:(ExchangeViewType)type {
    _type = type;
    if (type == ExchangeViewTypeSell) {
        [btn setTitle:@"点击出售" forState:UIControlStateNormal];
    } else if (type == ExchangeViewTypeBuy) {
        [btn setTitle:@"点击购买" forState:UIControlStateNormal];
    }
}


- (IBAction)clickBtn:(id)sender {
    if (_exchangeHandler) {
        _exchangeHandler(_type);
    }
}

- (void)setModel:(ExchangListModel *)model {
    _model = model;
    _username.text = model.nickName;
    _price.text = [NSString stringWithFormat:@"%.2f CNY", model.priceRatio];
    haveETH.text = [NSString stringWithFormat:@"%.2f %@", model.stock, model.currencyName];
}

@end
