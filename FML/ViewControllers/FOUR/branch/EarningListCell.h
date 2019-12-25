//
//  EarningListCell.h
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EarningListCell : UITableViewCell
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *typeLabel;
@property(nonatomic,strong) UILabel *priceLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong)CAGradientLayer *gradientLayer;

@end
