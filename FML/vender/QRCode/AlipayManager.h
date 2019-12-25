//
//  AlipayManager.h
//  FML
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayManager : NSObject

+ (void)getAlipayQRCode:(void (^)(NSString* str, BOOL isGetCodeStr))payBlock;

@end
