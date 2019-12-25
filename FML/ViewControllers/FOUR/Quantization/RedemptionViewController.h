//
//  RedemptionViewController.h
//  FML
//
//  Created by 车杰 on 2018/9/9.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"

@interface RedemptionViewController : MJBaseViewController
@property (nonatomic,strong)NSDictionary *resultDic;
@property (nonatomic,assign)BOOL isFocus;//是否是强制赎回
@property (nonatomic,strong) void (^RedemptionBlock)();
@end
