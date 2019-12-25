//
//  ExchangListModel.h
//  FML
//
//  Created by apple on 2018/8/8.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface ExchangListModel : MJBaseModel

@property (nonatomic, copy) NSString* userName;
@property (nonatomic, copy) NSString* currencyName,*nickName;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, copy) NSString* state;

@property (nonatomic, assign) CGFloat minLimit;
@property (nonatomic, assign) CGFloat maxLimit;
@property (nonatomic, assign) CGFloat stock;
//@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) CGFloat saleNumber;
@property (nonatomic, assign) CGFloat priceRatio;

@property (nonatomic, assign) NSUInteger createTime;
@property (nonatomic, assign) NSUInteger updateTime;
@property (nonatomic, assign) NSUInteger currencyId;
@property (nonatomic, assign) NSUInteger Id;


@end

//user_name` varchar(16) DEFAULT NULL COMMENT '用户名称',
//`currency_id` int(11) DEFAULT NULL COMMENT '币种ID',
//`currency_name` varchar(225) DEFAULT NULL COMMENT '币种名称',
//`min_limit` decimal(14,4) DEFAULT NULL COMMENT '购买最小值',
//`max_limit` decimal(14,4) DEFAULT NULL COMMENT '购买最大值',
//`type` varchar(32) NOT NULL COMMENT '购买：buy  出售：sale',
//`stock` decimal(14,4) NOT NULL COMMENT '库存',
//`price` decimal(14,4) NOT NULL COMMENT '单个币的单价，不是取的汇率，平台自定义',
//`sale_number` decimal(14,4) DEFAULT '0.0000' COMMENT '销量',
//`state` varchar(32) NOT NULL DEFAULT 'up' COMMENT '状态：上架：up  下架：down ',
//`create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
//`update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
