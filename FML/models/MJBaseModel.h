//
//  MJBaseModel.h
//  KangDuKe
//
//  Created by 车杰 on 16/12/11.
//  Copyright © 2016年 MJ Science and Technology Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MJBaseModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (id)arrayToModel:(NSArray *)array;
@end
