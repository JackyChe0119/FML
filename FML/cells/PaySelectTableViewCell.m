//
//  PaySelectTableViewCell.m
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "PaySelectTableViewCell.h"

@implementation PaySelectTableViewCell {
    
    __weak IBOutlet UILabel *_name;
    __weak IBOutlet UIImageView *_checkIV;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _checkIV.hidden = YES;
    _name.textColor = Color1D;
}

- (void)setModel:(BankCardModel *)model {
    _model = model;
    if (model.bankNumber == 100000000) {
        _name.text = model.bankName;
    } else {
        _name.text = [NSString stringWithFormat:@"%@(%ld)", model.bankName, model.bankNumber % 10000];
    }
    
    _checkIV.hidden = !model.isShowCheck;
}

@end
