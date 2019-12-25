//
//  SonNodeListCell.h
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SonNodeListCell : UITableViewCell
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong)CAGradientLayer *gradientLayer;
@property (nonatomic,strong)UIImageView *iconImageView,*accetypeIamgeview;
@end
