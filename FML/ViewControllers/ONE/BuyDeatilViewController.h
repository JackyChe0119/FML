//
//  BuyDeatilViewController.h
//  FML
//
//  Created by 车杰 on 2018/8/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"

@interface BuyDeatilViewController : MJBaseViewController
@property (nonatomic,strong) void (^dismissBlock)();
@property (nonatomic,assign)NSInteger orderId;
@property (nonatomic,assign)BOOL canPop;
@end
