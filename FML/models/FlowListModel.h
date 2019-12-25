//
//  FlowListModel.h
//  FML
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface FlowListModel : MJBaseModel

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* delType;
@property (nonatomic, strong) NSString* operation;
@property (nonatomic, strong) NSString* createTime;

@property (nonatomic, assign) CGFloat   price;
@property (nonatomic, assign) CGFloat   num;

@end
//id` int(11) unsigned NOT NULL AUTO_INCREMENT,
//`user_id` int(11) NOT NULL COMMENT '用户id',
//`user_no` varchar(16) NOT NULL DEFAULT '' COMMENT '用户编号',
//`remark` varchar(256) NOT NULL DEFAULT '' COMMENT '账目流水说明',
//`del_type` varchar(255) DEFAULT NULL COMMENT '处理类型，兑换：recharge  转账 income 提现  withdraw 佣金 commission 资产释放release，购买ICO消费  buy',
//`type` varchar(16) NOT NULL DEFAULT '' COMMENT '币种',
//`title` varchar(64) NOT NULL DEFAULT '' COMMENT '流水标题',
//`num` decimal(14,4) NOT NULL DEFAULT '0.0000' COMMENT '数量',
//`price` decimal(10,4) DEFAULT NULL COMMENT '当时交易金额',
//`operation` varchar(2) NOT NULL DEFAULT '' COMMENT '+,-',
//`status` tinyint(4) NOT NULL DEFAULT '0' COMMENT '状态1:正常0待确认－1取消，－2删除',
//`create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
//`update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
//`obj_id` int(11) DEFAULT NULL COMMENT '对象ID',
//PRIMARY KEY (`id`)
