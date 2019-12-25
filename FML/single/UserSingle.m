//
//  UserSingle.m
//  FML
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UserSingle.h"


@implementation UserSingle


static UserSingle *_user;

+ (UserSingle *)sharedUser {
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        _user = [[UserSingle alloc]init];
    });
    return _user;
}

+ (instancetype)alloc{
    NSCAssert(!_user, @"UserSingle类只能初始化一次");
    return [super alloc];
}

- (void)setResInfo:(NSDictionary *)dict {
    self.infoDic = dict;

    self.isAuth = [NSString stringWithFormat:@"%@", dict[@"isAuth"]].intValue;
    self.isPayPwd = [dict[@"isPayPwd"] isEqualToString:@"y"];
    self.userId = [NSString stringWithFormat:@"%@", dict[@"userId"]].intValue;
    self.msg = String(dict[@"msg"]);
    self.walletAddress = String(dict[@"walletAddress"]);
    self.inviteCode = String(dict[@"inviteCode"]);

    if ([dict[@"cardBack"] hasPrefix:@"http"]) {
        self.cardBack = dict[@"cardBack"];
    } else if (String(dict[@"cardBack"]).length > 10) {
        self.cardBack = [ALIYUN_OSS_IMAGE_DOMAIN stringByAppendingString:String(dict[@"cardBack"])];
    }
    if ([dict[@"cardFront"] hasPrefix:@"http"]) {
        self.cardFront = dict[@"cardFront"];
    } else if (String(dict[@"cardFront"]).length > 10) {
        self.cardFront = [ALIYUN_OSS_IMAGE_DOMAIN stringByAppendingString:String(dict[@"cardFront"])];
    }
    if ([dict[@"cardHand"] hasPrefix:@"http"]) {
        self.cardHand = dict[@"cardHand"];
    } else if (String(dict[@"cardHand"]).length > 10) {
        self.cardHand = [ALIYUN_OSS_IMAGE_DOMAIN stringByAppendingString:String(dict[@"cardHand"])];
    }
    if ([dict[@"alipayPicture"] hasPrefix:@"http"]) {
        self.alipayPicture = dict[@"alipayPicture"];
    } else if (String(dict[@"alipayPicture"]).length > 10) {
        self.alipayPicture = [ALIYUN_OSS_IMAGE_DOMAIN stringByAppendingString:String(dict[@"alipayPicture"])];
    }
    
    self.mobile = [NSString stringWithFormat:@"%@", dict[@"mobile"]];
    self.email = dict[@"email"];
    if (self.email==NULL||![self.email containsString:@"@"]) {
        self.email = @"";
    }
    NSString *accessToken = dict[@"accessToken"];
    if (accessToken) {
        [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:ACCESS_TOKEN];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    NSLog(@"-------------------->login success<---------------------");
}

- (void)setLoginInfo:(NSDictionary *)dict {

    self.isAnswer = [dict[@"isAnswer"] isEqualToString:@"y"];
    self.userNo = dict[@"userNo"];
    if ([dict[@"picture"] hasPrefix:@"http"]) {
        self.picture = dict[@"picture"];
    } else if (String(dict[@"picture"]).length > 10) {
        self.picture = [ALIYUN_OSS_IMAGE_DOMAIN stringByAppendingString:String(dict[@"picture"])];
    }
    
    self.nickName = dict[@"nickName"];
    
    [self setResInfo:dict];
}
- (void)setArray:(NSArray *)array {
    self.bitArray = array;
}
- (void)setInfo:(NSDictionary *)dict login:(BOOL)islogin{
    self.infoDic = dict;
    self.isLogin = islogin;
}
- (void)loginout {
    self.isPayPwd = NO;
    self.isAuth = 0;
    self.isAnswer = NO;
    self.userId = 0;
    self.msg = nil;
    self.userNo = nil;
    self.picture = nil;
    self.nickName = nil;
    self.walletAddress = nil;
    self.cardBack = nil;
    self.cardHand = nil;
    self.cardFront = nil;
    self.alipayPicture = nil;
    self.inviteCode = nil;
    self.email = @"";
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (void)login {
    [self login:nil];
}

- (void)login:(void (^)(void))success {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/user_info.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        
        if (responseMessage.errorMessage) {
        } else {
            [[UserSingle sharedUser] setLoginInfo:responseMessage.bussinessData];
            if (success) {
                success();
            }
        }
    }];
}
@end
