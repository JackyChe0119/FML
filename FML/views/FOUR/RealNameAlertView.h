//
//  RealNameAlertView.h
//  FML
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RealNameAlertView : UIView

- (instancetype)initWith:(NSString *)title;
@property (nonatomic, copy) void (^ closeHandler)();

@end
