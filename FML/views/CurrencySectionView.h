//
//  CurrencySectionView.h
//  FML
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencySectionView : UIView

@property (nonatomic, copy) void (^currencySelectIndex)(int index);
@property (nonatomic, copy) void (^openHander)();

@property (weak, nonatomic) IBOutlet UIButton *_btn5;
@property (weak, nonatomic) IBOutlet UIButton *_btn6;

@end
