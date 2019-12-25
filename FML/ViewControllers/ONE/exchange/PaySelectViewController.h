//
//  PaySelectViewController.h
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"
#import "PaySelectTableViewCell.h"

@interface PaySelectViewController : MJBaseViewController

@property (nonatomic, strong) NSMutableArray<BankCardModel *> *models;
@property (nonatomic, copy) void (^payModelHanlder) (BankCardModel* model);

@end
