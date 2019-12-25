//
//  ReleaseListModel.h
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface ReleaseListModel : MJBaseModel

@property (nonatomic, assign) NSInteger createTime;
@property (nonatomic, assign) CGFloat buyNum;
@property (nonatomic, assign) NSInteger dayNum;
@property (nonatomic, assign) CGFloat num,lockNumber;

@property (nonatomic, strong) NSString* recordNo;
@property (nonatomic, strong) NSString* remark;
@property (nonatomic, strong) NSString* currencyType;
@property (nonatomic, strong) NSString* email;

@end
