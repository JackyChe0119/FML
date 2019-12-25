//
//  ReleaseTableViewCell.h
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReleaseListModel.h"

@interface ReleaseTableViewCell : UITableViewCell

@property (nonatomic, strong) ReleaseListModel* model;

@end
