//
//  FMLAlertView.h
//  FML
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^alertBlock)();

@interface FMLAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title msg:(NSString *)msg;

- (void)addBtn:(NSString *)title titleColor:(UIColor *)color action:(alertBlock)action;

@end
