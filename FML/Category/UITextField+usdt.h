//
//  UITextField+usdt.h
//  FML
//
//  Created by apple on 2018/8/13.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UItextFieldMaxLengthObserver : NSObject

@end

@interface UITextField (usdt)

@property (nonatomic, assign) IBInspectable NSUInteger maxLength;

@end
