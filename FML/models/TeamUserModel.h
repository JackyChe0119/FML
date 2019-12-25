//
//  TeamUserModel.h
//  FML
//
//  Created by apple on 2018/7/30.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MJBaseModel.h"

@interface TeamUserModel : MJBaseModel

@property (nonatomic, copy) NSString* picture;
@property (nonatomic, copy) NSString* userNo;
@property (nonatomic, copy) NSString* createTime;
@property (nonatomic, copy) NSString* id;
@property (nonatomic, copy) NSString* userId;
@property (nonatomic, copy) NSString* nickName;
@property (nonatomic, copy) NSString* userType;

@end
