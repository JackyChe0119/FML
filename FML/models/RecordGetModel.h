//
//  RecordGetModel.h
//  FML
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface RecordGetModel : MJBaseModel

@property (nonatomic, copy) NSString* currencyType;
@property (nonatomic, copy) NSString* type;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) CGFloat num;

@end
