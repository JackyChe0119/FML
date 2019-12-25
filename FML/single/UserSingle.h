//
//  UserSingle.h
//  FML
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSingle : NSObject

@property (nonatomic, assign) BOOL      isPayPwd; //是否设置支付密码
@property (nonatomic, assign) int       isAuth;   //实名认证状态
@property (nonatomic, assign) BOOL      isAnswer; //
@property (nonatomic, assign) int       userId;   //用户ID
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, strong) NSArray*   bitArray;      //币种信息
@property (nonatomic, copy) NSString*   msg;      //实名认证信息
@property (nonatomic, copy) NSString*   userNo,*email;   //用户编号 推荐码  邮箱
@property (nonatomic, copy) NSString*   nickName;
@property (nonatomic, copy) NSString*   picture;
@property (nonatomic, copy) NSString*   walletAddress;
@property (nonatomic, copy) NSString*   cardBack;
@property (nonatomic, copy) NSString*   cardFront;
@property (nonatomic, copy) NSString*   cardHand;
@property (nonatomic, copy) NSString*   alipayPicture;
@property (nonatomic, copy) NSString*   inviteCode;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,assign)BOOL isLogin;
+ (UserSingle *)sharedUser;

- (void)setResInfo:(NSDictionary *)dict;
- (void)setLoginInfo:(NSDictionary *)dict;
- (void)loginout;
- (void)login;
- (void)setArray:(NSArray *)array;
- (void)login:(void (^)(void))success;
- (void)setInfo:(NSDictionary *)dict login:(BOOL)islogin;
@end
