//
//  WalletListModel.h
//  FML
//
//  Created by apple on 2018/7/30.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface WalletListModel : MJBaseModel

@property (nonatomic, copy) NSString* currencyId;
@property (nonatomic, copy) NSString* logo;
@property (nonatomic, copy) NSString* currenctName;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat increase;
@property (nonatomic, assign) CGFloat number;
@property (nonatomic, assign) CGFloat freezeNumber;

@end
