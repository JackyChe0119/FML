//
//  ICOListModel.h
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface ICOListModel : MJBaseModel

@property (nonatomic, assign) int lockDay;
@property (nonatomic, assign) NSUInteger releaseTime;
@property (nonatomic, assign) NSUInteger createTime;
@property (nonatomic, assign) CGFloat total;

@property (nonatomic, copy) NSString* currencyName;
@property (nonatomic, copy) NSString* status;

@property (nonatomic, assign) BOOL    isShowTop;
@property (nonatomic, assign) BOOL    isShowBottom;

@end

//`id` int(11) unsigned NOT NULL AUTO_INCREMENT,
//`user_id` int(11) NOT NULL COMMENT '用户id',
//`user_no` varchar(16) NOT NULL COMMENT '用户编号',
//`nick_name` varchar(32) DEFAULT NULL COMMENT '用户昵称',
//`mobile` varchar(11) DEFAULT NULL,
//`order_no` varchar(32) NOT NULL COMMENT '订单编号',
//`currency_id` int(11) NOT NULL COMMENT 'ICO资产id',
//`currency_name` varchar(64) NOT NULL DEFAULT '' COMMENT '币种名称',
//`lock_day` int(11) NOT NULL DEFAULT '0' COMMENT '锁定期限（天）',
//`label` text COMMENT '标签',
//`current_price` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '转换美金资产额度',
//`total` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '订单总额',
//`pay_type` varchar(16) NOT NULL DEFAULT 'eth' COMMENT '支付类型eth,btc',
//`pay_num` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '支付数量',
//`exchange_rate` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '当时汇率(单价)',
//`status` varchar(32) NOT NULL DEFAULT 'lock' COMMENT '状态 lock锁定中，release  释放',
//`release_time` date DEFAULT NULL COMMENT '确认释放时间',
//`create_time` datetime NOT NULL COMMENT '创建时间',
