//
//  HomeAddCell.m
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "HomeAddCell.h"

@implementation HomeAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = colorWithHexString(@"#f8f8f8");
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.icon_logo.layer.cornerRadius = 15;
    self.icon_logo.layer.masksToBounds = YES;
    self.icon_logo.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = Color1D;
    self.switchBtn.tintColor = ColorGray;
    self.switchBtn.onTintColor = ColorBlue;
    [self.switchBtn addTarget:self action:@selector(walletCardSave:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setModel:(CurrencySwitchModel *)model {
    _model = model;
    [_icon_logo sd_setImageWithURL:model.logo.toUrl];
    _titleLabel.text = model.currenctName;
    _switchBtn.on = [model.isShow isEqualToString:@"y"];
    if ([model.currenctName isEqualToString:@"ETH"] || [model.currenctName isEqualToString:@"FML"]) {
        _switchBtn.hidden = YES;
    } else {
        _switchBtn.hidden =NO;
    }
}

- (void)walletCardSave:(UISwitch *)swi {
    [(MJBaseViewController *)self.viewController showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"currencyId"] = _model.currencyId;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"wallet_card/save.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [(MJBaseViewController *)self.viewController hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [(MJBaseViewController *)self.viewController showToastHUD:responseMessage.errorMessage];
            self.switchBtn.on = !self.switchBtn.on;
        } else {
                if (_operaBlock) {
                    _operaBlock (swi.isOn);
                }
        }
    }];
}

@end
