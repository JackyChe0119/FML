//
//  PopoverView.h
//  FML
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles selectIndex:(int)index;
@property (nonatomic, copy) void (^popoverHandler)(NSString* currencyId, NSString *currencyName);

@end
