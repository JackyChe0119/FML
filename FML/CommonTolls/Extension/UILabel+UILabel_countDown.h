//
//  UILabel+UILabel_countDown.h
//  JobGame
//
//  Created by mc on 16/4/30.
//  Copyright © 2016年 KongGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (UILabel_countDown)
- (void)countdown:(void(^)(void))complete :(void(^)(void))uncomplete ;
- (void)Datecountdown:(NSInteger)time str:(NSString *)title final:(NSString *)finalStr :(void (^)(void))complete :(void(^)(void))uncomplete ;
- (void)DatecountdownOrder:(NSInteger)time str:(NSString *)title final:(NSString *)final :(void (^)(void))complete :(void(^)(void))uncomplete ;
@end
