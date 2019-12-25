//
//  CurrencyChartView.h
//  XjBaseProject
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKChooseView.h"

@interface CurrencyChartView : UIView

@property (nonatomic,strong) SKChooseView        *skChooseView;
@property (nonatomic,strong) UILabel             *titleLabel;
@property (nonatomic,strong) UILabel             *persentLabel;
@property (nonatomic, copy) NSArray              *timeArray;
@property (nonatomic, copy) NSArray              *dataArray;
@property (nonatomic,copy) NSString * currencyName;
-(instancetype)initWithFrame:(CGRect)frame currencyName:(NSString *)currencyName;

@end
