//
//  ExchangeView.h
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExchangeTableViewCell.h"

@interface ExchangeView : UIView

- (instancetype)initWithFrame:(CGRect)frame type:(ExchangeViewType)type;
@property (nonatomic, copy) NSString* currencyId;

@end
