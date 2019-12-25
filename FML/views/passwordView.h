//
//  passwordView.h
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WLUnitField.h"
@interface passwordView : UIView<WLUnitFieldDelegate>

@property (nonatomic,strong)WLUnitField *unitField;
@property (nonatomic,copy)NSString *password;

@property (nonatomic,strong) void (^passwordBlock)(NSInteger index);

@end
