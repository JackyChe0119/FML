//
//  TransactionTableViewCell.h
//  XjBaseProject
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlowListModel.h"
#import "RecordIncomeModel.h"
#import "RecordGetModel.h"

@interface TransactionTableViewCell : UITableViewCell

@property (nonatomic, strong) FlowListModel* model;
@property (nonatomic, strong) RecordIncomeModel* recordModel;
@property (nonatomic, strong) RecordGetModel* recordgetModel;


@end
