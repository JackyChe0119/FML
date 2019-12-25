//
//  BindPhoneViewController.m
//  FML
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "BindPhoneViewController.h"
#import "customInputView.h"
#import "RealNameAlertView.h"

@interface BindPhoneViewController ()

@property (nonatomic, strong) UIView* havePhoneView;
@property (nonatomic, strong) UIView* nophoneView;
@property (nonatomic, strong) UITextField* phoneTF;
@property (nonatomic,strong)customInputView *codeView, *phoneNumView;
@property (nonatomic, strong) UIButton* registerBtton;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navgationLeftButtonImage:backUp];
    
    if (self.isEmail) {
        [self NavigationItemTitle:@"绑定邮箱" Color:Color1D];
        if ([UserSingle sharedUser].email.length!=0) {
            [self layoutHavePhone];
        } else {
            [self layout];
        }
    }else {
        [self NavigationItemTitle:@"绑定手机号" Color:Color1D];

        if ([UserSingle sharedUser].mobile.length!=0) {
            [self layoutHavePhone];
        } else {
            [self layout];
        }
    }
}

- (void)layoutHavePhone {
    _havePhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, self.customNavView.bottom, ScreenWidth, ScreenHeight - NavHeight)];
    [self.view addSubview:_havePhoneView];
    
    UILabel* myphone = [UILabel new];
    if (self.isEmail) {
        myphone.text = [NSString stringWithFormat:@"您的邮箱：%@", [UserSingle sharedUser].email];
    }else {
        myphone.text = [NSString stringWithFormat:@"您的手机号：%@", [UserSingle sharedUser].mobile];
    }
    myphone.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    myphone.textColor = Color4D;
    [_havePhoneView addSubview:myphone];
    [myphone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(_havePhoneView).offset(40);
    }];
    
    UIButton* commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = ColorBlue;
    commitBtn.layer.cornerRadius = 3;
    if (self.isEmail) {
        [commitBtn setTitle:@"更换邮箱" forState:UIControlStateNormal];
    }else {
        [commitBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
    }
    [commitBtn addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [_havePhoneView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_havePhoneView).offset(-40);
        make.left.equalTo(_havePhoneView).offset(40);
        make.top.equalTo(myphone.mas_bottom).offset(20);
        make.height.mas_equalTo(50);
    }];
}

- (void)layout {
    _nophoneView = [[UIView alloc] initWithFrame:CGRectMake(0, self.customNavView.bottom, ScreenWidth, ScreenHeight - NavHeight)];
    [self.view addSubview:_nophoneView];
    
    UIView* tipView = [UIView new];
    [_nophoneView addSubview:tipView];
    
    UIButton* commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = ColorBlue;
    commitBtn.layer.cornerRadius = 3;
    commitBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
   
    [commitBtn addTarget:self action:@selector(bingPhone) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.isEmail) {
        [commitBtn setTitle:@"绑定邮箱" forState:UIControlStateNormal];
        if ([UserSingle sharedUser].email.length!=0) {
            tipView.backgroundColor = colorWithHexString(@"#b8bbcc");
            [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(_nophoneView);
                make.height.mas_equalTo(40);
            }];
            
            UILabel* tipLB = [UILabel new];
            tipLB.textColor = ColorWhite;
            tipLB.text = @"更换邮箱之后，下次登录需使用新邮箱。";
            tipLB.font = [UIFont systemFontOfSize:14];
            [_nophoneView addSubview:tipLB];
            [tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tipView).offset(20);
                make.centerY.equalTo(tipView);
            }];
            
            [commitBtn setTitle:@"更换邮箱" forState:UIControlStateNormal];
        }
    }else {
        [commitBtn setTitle:@"绑定手机号" forState:UIControlStateNormal];
        if ([UserSingle sharedUser].mobile.length!=0) {
            tipView.backgroundColor = colorWithHexString(@"#b8bbcc");
            [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(_nophoneView);
                make.height.mas_equalTo(40);
            }];
            
            UILabel* tipLB = [UILabel new];
            tipLB.textColor = ColorWhite;
            tipLB.text = @"更换手机号之后，下次登录需使用新手机号。";
            tipLB.font = [UIFont systemFontOfSize:14];
            [_nophoneView addSubview:tipLB];
            [tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tipView).offset(20);
                make.centerY.equalTo(tipView);
            }];
            
            [commitBtn setTitle:@"更换手机号" forState:UIControlStateNormal];
        }
    }

    
    _phoneNumView = [[customInputView alloc] initWithFrame:RECT(10,12 , ScreenWidth-80, 55) style:0];
    _phoneNumView.leftImageStr = @"131";
    if (self.isEmail) {
        _phoneNumView.inputTextField.placeholder = @"请输入邮箱";
    }else {
        _phoneNumView.inputTextField.placeholder = @"请输入手机号";
    }
    _phoneNumView.lineView.left = 30;
//    _phoneNumView.inputTextField.keyboardType = pad
    [_phoneNumView.inputTextField addTarget:self action:@selector(rigisterLengthCount) forControlEvents:UIControlEventEditingChanged];
    [_nophoneView addSubview:_phoneNumView];
    [_phoneNumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_bottom).offset(30);
        make.left.equalTo(_nophoneView).offset(10);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(ScreenWidth-50);
    }];
    
    __weak typeof(self) weakSelf = self;
    _codeView = [[customInputView alloc]initWithFrame:RECT(10,GETY(_havePhoneView.frame) , ScreenWidth-50, 55) style:2];
    _codeView.leftImageStr = @"1231";
    _codeView.lineView.left = 30;
    _codeView.lineView.width -= 30;
    if (self.isEmail) {
        _codeView.inputTextField.placeholder = @"请输入邮箱验证码";
    }else {
        _codeView.inputTextField.placeholder = @"请输入短信验证码";
    }
    _codeView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    _codeView.inputViewBlcok = ^(NSInteger type) {
        if (type==2) { //获取验证码
            [weakSelf doResuestToGetCode];
        }
    };
    [_codeView.inputTextField addTarget:self action:@selector(rigisterLengthCount) forControlEvents:UIControlEventEditingChanged];
    [_nophoneView addSubview:_codeView];
    [_codeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneNumView.mas_bottom).offset(0);
        make.left.equalTo(_nophoneView).offset(10);
        make.height.mas_equalTo(55);
        make.width.mas_equalTo(ScreenWidth-50);
    }];
    

    [_nophoneView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_nophoneView).offset(-40);
        make.left.equalTo(_nophoneView).offset(40);
        make.top.equalTo(_codeView.mas_bottom).offset(78);
        make.height.mas_equalTo(50);
    }];
    _registerBtton = commitBtn;
}

- (void)change {
    _havePhoneView.hidden = YES;
    if (self.isEmail) {
        self.titleLabel.text = @"更改邮箱";
    }else {
        self.titleLabel.text = @"更改手机号";
    }
    [self layout];
}


- (void)rigisterLengthCount {
    if (_phoneNumView.inputTextField.text.length!=0) {
        _registerBtton.userInteractionEnabled = YES;
        [_registerBtton setBackgroundColor:ColorBlue];
    }else {
        _registerBtton.userInteractionEnabled = NO;
        [_registerBtton setBackgroundColor:ColorGray];
    }
}

- (void)doResuestToGetCode {
    if (self.isEmail) {
        if (![_phoneNumView.inputTextField.text containsString:@"@"]) {
            [self showToastHUD:@"请输入正确的邮箱"];
            return;
        }
        [self getEmail];
    }else {
        if (!_phoneNumView.inputTextField.text.isValidMobile) {
            [self showToastHUD:@"请输入正确的手机号"];
            return;
        }
        [self getMobile];
    }
}
- (void)getEmail {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"email"] = _phoneNumView.inputTextField.text;
    dict[@"type"] = @"bind";
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"email/send_email.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showToastHUD:@"验证码已发送"];
            dispatch_async(dispatch_get_main_queue(), ^{
                _codeView.needCount_down = YES;
            });
        }
    }];
}
- (void)getMobile {
        [self showProgressHud];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        dict[@"mobile"] = _phoneNumView.inputTextField.text;
        dict[@"type"] = @"bind";
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"send/check_code.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [self hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [self showToastHUD:responseMessage.errorMessage];
            } else {
                [self showToastHUD:@"验证码已发送"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _codeView.needCount_down = YES;
                });
            }
        }];
}
- (void)bingPhone {
    if (self.isEmail) {
        if (![_phoneNumView.inputTextField.text containsString:@"@"]) {
            [self showToastHUD:@"请输入正确的邮箱"];
            return;
        }
        if (_codeView.inputTextField.text.length==0) {
            [self showToastHUD:@"请输入邮箱验证码"];
            return;
        }
        [self showProgressHud];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        dict[@"email"] = _phoneNumView.inputTextField.text;
        dict[@"emailCode"] = _codeView.inputTextField.text;
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/bind_email.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [self hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [self showToastHUD:responseMessage.errorMessage];
            } else {
                RealNameAlertView* alertView = [[RealNameAlertView alloc] initWith:[UserSingle sharedUser].mobile.length!=0 ? @"邮箱改绑成功" : @"邮箱绑定成功"];
                [self showShadowViewWithColor:YES];
                [self.shadowView addSubview:alertView];
                [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.shadowView);
                    make.width.mas_equalTo(ScreenWidth * 0.8);
                }];
                alertView.closeHandler = ^{
                    [self hiddenShadowView];
                    [UserSingle sharedUser].email = _phoneNumView.inputTextField.text;
                    [[UserSingle sharedUser] login:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                };
            }
        }];
        

    }else {
        if (!_phoneNumView.inputTextField.text.isValidMobile) {
            [self showToastHUD:@"请输入正确的手机号"];
            return;
        }
        if (_codeView.inputTextField.text.length==0) {
            [self showToastHUD:@"请输入短信验证码"];
            return;
        }
        [self showProgressHud];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        dict[@"mobileNo"] = _phoneNumView.inputTextField.text;
        dict[@"mobileCode"] = _codeView.inputTextField.text;
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/bind_mobile.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [self hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [self showToastHUD:responseMessage.errorMessage];
            } else {
                RealNameAlertView* alertView = [[RealNameAlertView alloc] initWith:[UserSingle sharedUser].mobile.length!=0 ? @"手机号改绑成功" : @"手机号绑定成功"];
                [self showShadowViewWithColor:YES];
                [self.shadowView addSubview:alertView];
                [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.shadowView);
                    make.width.mas_equalTo(ScreenWidth * 0.8);
                }];
                alertView.closeHandler = ^{
                    [self hiddenShadowView];
                    [UserSingle sharedUser].mobile = _phoneNumView.inputTextField.text;
                    [[UserSingle sharedUser] login:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                };
            }
        }];
    }
}
@end
