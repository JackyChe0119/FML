//
//  SellOrBuyViewController.h
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"
#import "ExchangeView.h"

@interface SellOrBuyViewController : MJBaseViewController

@property (nonatomic, assign) ExchangeViewType type;
@property (nonatomic, strong) ExchangListModel* exchangeModel;

@end
