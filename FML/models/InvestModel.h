//
//  InvestModel.h
//  FML
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InvestModel : MJBaseModel

@property (nonatomic, copy) NSString*   createTime;
@property (nonatomic, copy) NSString*   currenctyName,*buyCurrencyName;
@property (nonatomic, copy) NSString*   datTime;
@property (nonatomic, copy) NSString*   ethRate;
@property (nonatomic, copy) NSString*   label;
@property (nonatomic, copy) NSString*   logo;
@property (nonatomic, assign) int       icoId;
@property (nonatomic, strong) NSString* isCochain;

@property (nonatomic, assign) CGFloat   currentPrice;

@end 
