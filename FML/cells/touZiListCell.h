//
//  touZiListCell.h
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestModel.h"

@interface touZiListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tag1;
@property (weak, nonatomic) IBOutlet UILabel *tag2;
@property (weak, nonatomic) IBOutlet UILabel *tag3;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lookDetail;
@property (weak, nonatomic) IBOutlet UILabel *openPriceLB;
@property (weak, nonatomic) IBOutlet UIImageView *topRight;

@property (nonatomic, copy) void (^detailClickBlock)();

@property (nonatomic, strong) InvestModel* model;

@end
