//
//  TiXiViewController.h
//  FML
//
//  Created by 车杰 on 2018/9/5.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"

@interface TiXiViewController : MJBaseViewController
@property (nonatomic,strong)NSDictionary *resultDic;
@property (nonatomic,strong) void (^tixiBlock)();
@end
