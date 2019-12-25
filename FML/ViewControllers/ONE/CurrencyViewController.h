//
//  CurrencyViewController.h
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"
#import "WalletListModel.h"

@interface CurrencyViewController : MJBaseViewController

@property (nonatomic, copy) NSString* currencyName;
@property (nonatomic, copy) NSString* currencyId;
@property (nonatomic, copy) NSString* currencyIcon;
@property (nonatomic, strong) WalletListModel* walletModel;

@end
