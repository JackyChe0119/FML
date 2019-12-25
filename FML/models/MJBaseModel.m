//
//  MJBaseModel.m
//  KangDuKe
//
//  Created by 车杰 on 16/12/11.
//  Copyright © 2016年 MJ Science and Technology Ltd. All rights reserved.
//

#import "MJBaseModel.h"

@implementation MJBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}

+ (NSMutableArray *)arrayToModel:(NSArray *)array {
    NSMutableArray* modelArr = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        id model = [[self alloc] initWithDictionary:dict];
        [modelArr addObject:model];
    }
    return modelArr;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count;
    Ivar *ivar = class_copyIvarList([self class], &count);
    for (int i=0; i<count; i++) {
        Ivar iva = ivar[i];
        const char *name = ivar_getName(iva);
        NSString *strName = [NSString stringWithUTF8String:name];
        //利用KVC取值
        id value = [self valueForKey:strName];
        [aCoder encodeObject:value forKey:strName];
    }
    free(ivar);
}

//解档
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivar = class_copyIvarList([self class], &count);
        for (int i = 0; i < count; i++) {
            Ivar iva = ivar[i];
            const char *name = ivar_getName(iva);
            NSString *strName = [NSString stringWithUTF8String:name];
            //进行解档取值
            id value = [aDecoder decodeObjectForKey:strName];
            //利用KVC对属性赋值
            [self setValue:value forKey:strName];
        }
        free(ivar);
    }
    return self;
}


/**
 *  对特殊字段进行处理
 *
 *  @param value value description
 *  @param key   key description
 */
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"Id"];
    }
    if ([key isEqualToString:@"description"]) {
        [self setValue:value forKey:@"Description"];
    }
}

@end
