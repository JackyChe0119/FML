//
//  ReSetPswViewController.h
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"
#import "FindPswViewController.h"

@interface ReSetPswViewController : MJBaseViewController

@property (nonatomic, copy) NSString* phoneNum;
@property (nonatomic, copy) NSString* checkCode;
@property (nonatomic, assign) FMLPasswordType type;
@property (nonatomic,assign) BOOL CanPopRoot;
@end
