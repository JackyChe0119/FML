//
//  SetBuyPasswordViewController.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "FMLTextField.h"
#import "loginViewController.h"
#import "UITextField+usdt.h"

@interface SetPasswordViewController ()

@property (nonatomic, strong) FMLTextField* oldPassword;
@property (nonatomic, strong) FMLTextField* password;
@property (nonatomic, strong) FMLTextField* againPassword;

@end

@implementation SetPasswordViewController

- (void)setType:(FMLPasswordType)type {
    _type = type;
    switch (type) {
        case FMLPasswordTYPESetNewBuyNoPush:
        case FMLPasswordTypeSetNewBuy:{
            [self NavigationItemTitle:@"设置支付密码" Color:Color1D];
        }
            break;
        case FMLPasswordTYPEChangeBuyNoPush:
        case FMLPasswordTypeChangeBuy:{
            [self NavigationItemTitle:@"重置支付密码" Color:Color1D];
        }
            break;
        case FMLPasswordTypeLogin:{
            [self NavigationItemTitle:@"重置登录密码" Color:Color1D];
        }
            break;
        default:
            break;
    }
    if (_type == FMLPasswordTYPESetNewBuyNoPush || _type == FMLPasswordTYPEChangeBuyNoPush) {
        [self navgationRightButtonImage:@"close"];
        [self.view addSubview:self.rightButton];
    } else {
        [self navgationLeftButtonImage:backUp];
        [self.view addSubview:self.leftButton];
    }
    [self setView];
}

- (void)type:(NSNumber *)num {
    [self setType:(FMLPasswordType)num.integerValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = ColorWhite;
    
}


- (void)setView {

    _oldPassword = [FMLTextField new];
    _oldPassword.textfield.placeholder = @"输入旧密码";
    _oldPassword.tag = 10000;
    [self.view addSubview:_oldPassword];
    [_oldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40);
        make.left.equalTo(self.view).offset(40);
        make.top.equalTo(self.view).offset(StatusBarHeight + 84);
        make.height.mas_equalTo((_type == FMLPasswordTypeSetNewBuy || _type == FMLPasswordTYPESetNewBuyNoPush) ? 0 : 35);
    }];
    _oldPassword.hidden = (_type == FMLPasswordTypeSetNewBuy || _type == FMLPasswordTYPESetNewBuyNoPush);

    _password = [FMLTextField new];
    _password.textfield.placeholder = @"输入新密码";
    _password.select = YES;
    [self.view addSubview:_password];
    [_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(_oldPassword);
        make.top.equalTo(_oldPassword.mas_bottom).offset((_type == FMLPasswordTypeSetNewBuy || _type == FMLPasswordTYPESetNewBuyNoPush) ? 0 : 20);
        make.height.mas_equalTo(35);
    }];

    _againPassword = [FMLTextField new];
    _againPassword.textfield.placeholder = @"再次输入新密码";
    _againPassword.select = YES;
    [self.view addSubview:_againPassword];
    [_againPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(_password);
        make.top.equalTo(_password.mas_bottom).offset(20);
        make.height.mas_equalTo(35);
    }];

    UIButton* commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = ColorBlue;
    commitBtn.layer.cornerRadius = 3;
    [commitBtn setTitle:_type == FMLPasswordTYPESetNewBuyNoPush ? @"完成设置" : @"确定" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitPassword) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_againPassword);
        make.top.equalTo(_againPassword.mas_bottom).offset(50);
        make.height.mas_equalTo(50);
    }];
    
    if (_type == FMLPasswordTypeChangeBuy || _type == FMLPasswordTypeLogin) {
        UIButton* forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [forgetBtn setTitleColor:Color4D forState:UIControlStateNormal];
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [forgetBtn addTarget:self action:@selector(findPassword) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:forgetBtn];
        [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(commitBtn);
            make.top.equalTo(commitBtn.mas_bottom).offset(15);
        }];
    }
    
    if (_type == FMLPasswordTYPESetNewBuyNoPush) {
        UILabel* tip = [UILabel new];
        tip.textColor = ColorRed;
        tip.font = [UIFont systemFontOfSize:14];
        tip.text = @"请牢记您的支付密码，天大地大钱钱最大哦";
        [self.view addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(commitBtn);
            make.top.equalTo(commitBtn.mas_bottom).offset(15);
        }];
    }
    
    if (_type != FMLPasswordTypeLogin) {
        _oldPassword.textfield.keyboardType = UIKeyboardTypeNumberPad;
        _password.textfield.keyboardType = UIKeyboardTypeNumberPad;
        _againPassword.textfield.keyboardType = UIKeyboardTypeNumberPad;
        _oldPassword.textfield.maxLength = 6;
        _password.textfield.maxLength = 6;
        _againPassword.textfield.maxLength = 6;
    }
    
}

- (void)commitPassword {

    for (FMLTextField* view in self.view.subviews) {
        if ([view isKindOfClass:[FMLTextField class]]) {
            if (view.tag == 10000 && (_type == FMLPasswordTypeSetNewBuy || _type == FMLPasswordTYPESetNewBuyNoPush)) {
                
            } else if (view.textfield.text.length == 0 || view.textfield.text == nil) {
                
                [self showToastHUD:[@"请" stringByAppendingString:view.textfield.placeholder]];
                return;
            } else if (view.textfield.text.length != 6 && _type != FMLPasswordTypeLogin) {
                [self showToastHUD:@"支付密码为6位数字"];
                return;
            }
        }
    }
//    if (_type != FMLPasswordTypeLogin) {
//        [self showToastHUD:@"支付密码为6位数字"];
//        return;
//    }
    if (![_password.textfield.text isEqualToString:_againPassword.textfield.text]) {
        [self showToastHUD:@"两次输入不一致"];
        return;
    }
    
    NSString* urlStr = @"user/update_pay_pwd.htm";
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    switch (_type) {
        case FMLPasswordTypeLogin:
            urlStr = @"user/update_pwd.htm";
            break;
        case FMLPasswordTYPESetNewBuyNoPush:
        case FMLPasswordTypeSetNewBuy:
            dict[@"type"] = @"add";
            break;
        case FMLPasswordTYPEChangeBuyNoPush:
        case FMLPasswordTypeChangeBuy:
            dict[@"type"] = @"change";
            break;
        default:
            break;
    }
    dict[@"oldPwd"] = _oldPassword.textfield.text;
    dict[@"newPwd"] = _password.textfield.text;
    dict[@"comfirmPwd"] = _againPassword.textfield.text;
    
    [self showProgressHud];
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:urlStr.apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        [[UserSingle sharedUser] login];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (_type == FMLPasswordTypeLogin) {
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:ACCESS_TOKEN];
                [[NSUserDefaults standardUserDefaults]synchronize];
                [[UIApplication sharedApplication].delegate window].rootViewController = [[loginViewController alloc]init];
                
            } else {
                [UserSingle sharedUser].isPayPwd = _type == FMLPasswordTypeSetNewBuy;
                [self showToastHUD:_type == FMLPasswordTypeChangeBuy ? @"重置支付密码成功" : @"设置支付密码成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (_type == FMLPasswordTYPESetNewBuyNoPush) {
                        [UserSingle sharedUser].isPayPwd = _type == FMLPasswordTYPESetNewBuyNoPush;
                        [self dismissViewControllerAnimated:YES completion:nil];
                    } else {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                });
            }
        }
    }];
}

- (void)findPassword {
    FindPswViewController* vc = [FindPswViewController new];
    vc.type = _type;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navgationRightButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
