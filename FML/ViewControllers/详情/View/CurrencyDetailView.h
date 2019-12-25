//
//  CurrencyDetailView.h
//  XjBaseProject
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrencyItem;
@interface CurrencyDetailView : UIView

@property (nonatomic, strong) NSMutableDictionary* currencyDetailDict;
@property (nonatomic, copy) NSArray* klineDict;
@property (nonatomic, copy) NSString*     logo;
@property (nonatomic,assign) BOOL isFml;
@property (nonatomic, strong) UILabel*      lockLB;
@property (nonatomic, strong) UILabel*      freeLB;
@property (nonatomic, strong) UILabel*      currencyNameLabel;
@property (nonatomic, copy) NSString *currencyName;
@property (nonatomic,copy) NSString *Namecurrency;
@property (nonatomic, copy) void (^kingEnumHandle)(NSString *KEnum);

- (instancetype)initWithFrame:(CGRect)frame isLock:(BOOL)isLock currencyName:(NSString *)currencyName;
@end

@interface CurrencyItem : UIView

@property (nonatomic, copy) NSString*   leftStr;
@property (nonatomic, copy) NSString*   rightStr;

@end
