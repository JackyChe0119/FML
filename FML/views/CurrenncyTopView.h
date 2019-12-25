//
//  CurrenncyTopView.h
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyDetailView.h"

@interface CurrenncyTopView : UIView

@property (nonatomic, strong) UIButton* leftButton;
@property (nonatomic, strong) UILabel*  titleLabel;

@property (nonatomic, strong) UIImageView*  currencyIcon;
@property (nonatomic, strong) UILabel*      currencyName;
@property (nonatomic, strong) UILabel*      currencyNum;

@property (nonatomic, strong) CurrencyItem* item1;
@property (nonatomic, strong) CurrencyItem* item2;
@property (nonatomic, strong) CurrencyItem* item3;
@property (nonatomic, strong) CurrencyItem* item4;

@property (nonatomic, copy) NSString*       rightStr;

@end 
