//
//  ziChanListCell.h
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletListModel.h"

@interface ziChanListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabel_Width;
@property (weak, nonatomic) IBOutlet UILabel *precentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *topNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottonPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *lockNumber;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@property (nonatomic, strong) WalletListModel* model;

@end
