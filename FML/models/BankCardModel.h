//
//  BankCardModel.h
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface BankCardModel : MJBaseModel

@property (nonatomic, strong) NSString* bankName;

@property (nonatomic, assign) NSInteger bankNumber;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL      isShowCheck;
@property (nonatomic, assign) NSInteger Id;
@end
