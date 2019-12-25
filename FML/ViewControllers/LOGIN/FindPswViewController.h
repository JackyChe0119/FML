//
//  FindPswViewController.h
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"

typedef NS_ENUM(NSInteger, FMLPasswordType) {
    FMLPasswordTypeSetNewBuy = 0,
    FMLPasswordTypeChangeBuy,
    FMLPasswordTypeLogin,
    FMLPasswordTYPESetNewBuyNoPush,
    FMLPasswordTYPEChangeBuyNoPush,
};

@interface FindPswViewController : MJBaseViewController

@property (nonatomic, assign) FMLPasswordType   type;

@property (nonatomic, assign) BOOL CanPopRoot;

@end
