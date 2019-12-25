//
//  MyBranchListModel.h
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface MyBranchListModel : MJBaseModel

@property (nonatomic, assign) CGFloat   lockNumber;
@property (nonatomic, assign) CGFloat   lockCommissNumber;
@property (nonatomic, copy) NSString*   logo;
@property (nonatomic, copy) NSString*   currencyName;
@property (nonatomic, assign) int       currencyId;
@property (nonatomic, assign) int       walletCardId;

@end
