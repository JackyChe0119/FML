//
//  BuyView.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "BuyView.h"

@implementation BuyView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _okBtn.layer.cornerRadius = 5;
    _okBtn.backgroundColor = ColorBlue;
    
    _exchangeLB.textColor = Color1D;
    _numLB.textColor = Color1D;
    _FMLLB.textColor = Color1D;
}

@end
