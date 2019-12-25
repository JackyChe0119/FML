//
//  HomeAddCell.h
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencySwitchModel.h"

@interface HomeAddCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon_logo;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@property (nonatomic,strong) void (^operaBlock)(BOOL isOn);
@property (nonatomic, strong) CurrencySwitchModel* model;

@end
