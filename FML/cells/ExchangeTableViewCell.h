//
//  ExchangeTableViewCell.h
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangListModel.h"

typedef NS_ENUM(NSInteger, ExchangeViewType) {
    ExchangeViewTypeBuy = 0,
    ExchangeViewTypeSell,
};


@interface ExchangeTableViewCell : UITableViewCell

@property (nonatomic, assign) ExchangeViewType type;
@property (nonatomic, copy) void (^exchangeHandler) (ExchangeViewType type);
@property (nonatomic, strong) ExchangListModel* model;

@end
