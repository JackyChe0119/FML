//
//  NSString+Category.h
//  FML
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)

- (NSString *)apifml;
- (NSURL *)toUrl;
- (BOOL)isValidMobile;//手机号校验
- (BOOL)validateIDCardNumber;//身份证校验
//- (BOOL)luhmCheck;//银行卡校验
- (BOOL)checkCardNo:(NSString*)cardNo;//银行卡校验
@end
