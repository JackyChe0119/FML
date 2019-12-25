//
//  NickNameChangeVC.h
//  FML
//
//  Created by 车杰 on 2018/9/3.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"

@interface NickNameChangeVC : MJBaseViewController
@property (nonatomic,strong) void (^nickNameBlock)(NSString *text);
@property (nonatomic,copy)NSString *nickName;
@end
