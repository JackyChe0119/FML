//
//  TimeTableViewCell.h
//  FML
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICOListModel.h"

@class DashLineView;
@interface TimeTableViewCell : UITableViewCell

@property (nonatomic, strong) ICOListModel* model;

@end

@interface DashLineView : UIView
- (instancetype)initWithFrame:(CGRect)frame withLineLength:(NSInteger)lineLength withLineSpacing:(NSInteger)lineSpacing withLineColor:(UIColor *)lineColor;
@end
