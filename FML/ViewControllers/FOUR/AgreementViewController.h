//
//  AgreementViewController.h
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"

typedef NS_ENUM(NSInteger, FMLAgreementType) {
    FMLAgreementTypeXY = 0,
    FMLAgreementTypeFYchecked,
    FMLAgreementTypeFYuncheck,
    FMLAgreementTypeFYXS,
};


@interface AgreementViewController : MJBaseViewController

@property (nonatomic, assign) FMLAgreementType  type;

@end
