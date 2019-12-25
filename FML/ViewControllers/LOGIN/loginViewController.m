//
//  loginViewController.m
//  ManggeekBaseProject
//
//  Created by 车杰 on 2017/12/20.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import "loginViewController.h"
#import "customInputView.h"
#import "FindPswViewController.h"
#import "MainViewController.h"
#import "WebViewController.h"
#import "AgreementViewController.h"
#import "AnswerViewController.h"
#define FITGEIGHT 185*ScreenWidth/375.0

@interface loginViewController ()
@property (nonatomic,strong)UIImageView *itemImageView;
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)customInputView *userInputView,*passwordInputView;
@property (nonatomic,strong)UIButton *loginButton,*registerBtton;
@property (nonatomic,strong)customInputView *nickNameView,*phoneNumView,*codeView,*passwordView,*surePasswordView,*invateCodeView;

@property (nonatomic, assign) BOOL      isRes;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_isRes) {
        [_baseScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
    } else {
        [_baseScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
#pragma mark 布局视图
- (void)layoutUI {
    
    __weak typeof(self)weakSelf = self;
    
    UIImageView *topImageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, FITGEIGHT) imageName:@"icon_login_top"];
    [self.view addSubview:topImageView];
    
    UIButton *loginBtn = [UIButton createTextButtonWithFrame:RECT(0, FITGEIGHT-40, ScreenWidth/2.0, 40) bgColor:nil textColor:[UIColor whiteColor] font:14 bold:YES title:@"登录"];
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 100;
    [self.view addSubview:loginBtn];
    
    UIButton *registerBtn = [UIButton createTextButtonWithFrame:RECT(ScreenWidth/2.0, FITGEIGHT-40, ScreenWidth/2.0, 40) bgColor:nil textColor:[UIColor whiteColor] font:14 bold:YES title:@"注册"];
    [registerBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    registerBtn.tag = 200;
    [self.view addSubview:registerBtn];
    
    _itemImageView = [UIImageView createImageViewWithFrame:RECT(ScreenWidth/4.0-10, FITGEIGHT-8, 20, 10) imageName:@"icon_top_select"];
    _itemImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_itemImageView];
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0,FITGEIGHT, ScreenWidth, ScreenHeight-FITGEIGHT)];
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.showsHorizontalScrollIndicator = NO;
    _baseScrollView.scrollEnabled = NO;
    [self.view addSubview:_baseScrollView];
    
    _userInputView = [[customInputView alloc] initWithFrame:RECT(40,12 , ScreenWidth-80, 55) style:0];
    _userInputView.leftImageStr = @"icon_user";
    _userInputView.inputTextField.placeholder = @"邮箱/手机号";
    [_userInputView.inputTextField addTarget:self action:@selector(userOrPasswordLengthCount) forControlEvents:UIControlEventEditingChanged];
    [_baseScrollView addSubview:_userInputView];
    
    _passwordInputView = [[customInputView alloc]initWithFrame:RECT(40,GETY(_userInputView.frame) , ScreenWidth-80, 55) style:0];
    _passwordInputView.leftImageStr = @"icon_password";
    _passwordInputView.inputTextField.placeholder = @"密码";
    _passwordInputView.inputTextField.secureTextEntry = YES;
    [_passwordInputView.inputTextField addTarget:self action:@selector(userOrPasswordLengthCount) forControlEvents:UIControlEventEditingChanged];
    [_baseScrollView addSubview:_passwordInputView];
    
    UILabel *forgetLabel = [UILabel new];
    [forgetLabel rect:RECT(ScreenWidth-120, GETY(_passwordInputView.frame)+10, 80, 20) aligment:Right font:13 isBold:NO text:@"忘记密码" textColor:ColorBlue superView:_baseScrollView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetPassword)];
//    forgetLabel.userInteractionEnabled = YES;
//    [forgetLabel addGestureRecognizer:tap];
    UIButton* forgetbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetbtn.left = forgetLabel.left - 20;
    forgetbtn.top = forgetLabel.top;
    forgetbtn.width = forgetLabel.width + 40;
    forgetbtn.height = forgetLabel.height + 20;
    [_baseScrollView addSubview:forgetbtn];
    [forgetbtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    
    _loginButton = [UIButton createTextButtonWithFrame:RECT(40, GETY(_passwordInputView.frame)+104, ScreenWidth-80, 50) bgColor:colorWithHexString(@"#ebebeb") textColor:[UIColor whiteColor] font:14 bold:YES title:@"登录"];
    [_loginButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginButton.tag = 300;
    _loginButton.layer.cornerRadius = 5;
    _loginButton.layer.masksToBounds = YES;
    _loginButton.userInteractionEnabled = NO;
    [_baseScrollView addSubview:_loginButton];
    
    UIButton *autoLoginBtn = [UIButton createTextButtonWithFrame:RECT(45, GETY(_loginButton.frame)+5, 30, 30) bgColor:nil textColor:[UIColor whiteColor] font:14 bold:YES title:@""];
    [autoLoginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    autoLoginBtn.tag = 400;
    autoLoginBtn.selected = YES;
    [autoLoginBtn setImage:IMAGE(@"icon_select") forState:UIControlStateNormal];
    [_baseScrollView addSubview:autoLoginBtn];
    
    UILabel *nextLoginLabel = [UILabel new];
    [nextLoginLabel rect:RECT(GETX(autoLoginBtn.frame)+5,GETY(_loginButton.frame)+10, 80, 20) aligment:Left font:13 isBold:NO text:@"下次自动登录" textColor:colorWithHexString(@"#4d5066") superView:_baseScrollView];
    
    _nickNameView = [[customInputView alloc]initWithFrame:RECT(40+ScreenWidth,12 , ScreenWidth-80, 55) style:0];
    _nickNameView.leftImageStr = @"icon_phonenum";
    _nickNameView.inputTextField.placeholder = @"设置昵称";
    _nickNameView.inputTextField.keyboardType= UIKeyboardTypeDefault;
    [_baseScrollView addSubview:_nickNameView];
    
    _phoneNumView = [[customInputView alloc]initWithFrame:RECT(40+ScreenWidth,GETY(_nickNameView.frame) , ScreenWidth-80, 55) style:0];
    _phoneNumView.leftImageStr = @"icon_mobile_register";
    _phoneNumView.inputTextField.placeholder = @"请输入手机号码";
    [_phoneNumView.inputTextField addTarget:self action:@selector(rigisterLengthCount) forControlEvents:UIControlEventEditingChanged];
    [_baseScrollView addSubview:_phoneNumView];
    
    _codeView = [[customInputView alloc]initWithFrame:RECT(40+ScreenWidth,GETY(_phoneNumView.frame) , ScreenWidth-80, 55) style:2];
    _codeView.leftImageStr = @"icon_checkcode";
    _codeView.inputTextField.placeholder = @"短信验证码";
    _codeView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_codeView.inputTextField addTarget:self action:@selector(rigisterLengthCount) forControlEvents:UIControlEventEditingChanged];
    _codeView.inputViewBlcok = ^(NSInteger type) {
        if (type==2) { //获取验证码
            [weakSelf doResuestToGetCode];
        }
    };
    [_baseScrollView addSubview:_codeView];
    
    _passwordView = [[customInputView alloc]initWithFrame:RECT(40+ScreenWidth,GETY(_codeView.frame) , ScreenWidth-80, 55) style:1];
    _passwordView.leftImageStr = @"icon_password";
    _passwordView.inputTextField.placeholder = @"设置密码";
    [_passwordView.inputTextField addTarget:self action:@selector(rigisterLengthCount) forControlEvents:UIControlEventEditingChanged];
    _passwordView.inputTextField.secureTextEntry = YES;
    _passwordView.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
    _passwordView.needencryption = YES;
    [_baseScrollView addSubview:_passwordView];
    
    _surePasswordView = [[customInputView alloc]initWithFrame:RECT(40+ScreenWidth,GETY(_passwordView.frame) , ScreenWidth-80, 55) style:1];
    _surePasswordView.leftImageStr = @"icon_invatecode";
    _surePasswordView.inputTextField.placeholder = @"确认密码";
    [_surePasswordView.inputTextField addTarget:self action:@selector(rigisterLengthCount) forControlEvents:UIControlEventEditingChanged];
    _surePasswordView.inputTextField.secureTextEntry = YES;
    _surePasswordView.needencryption = YES;
    _surePasswordView.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_baseScrollView addSubview:_surePasswordView];
    
    _invateCodeView = [[customInputView alloc]initWithFrame:RECT(40+ScreenWidth,GETY(_surePasswordView.frame) , ScreenWidth-80, 55) style:0];
    _invateCodeView.leftImageStr = @"icon_invatecode";
    _invateCodeView.inputTextField.placeholder = @"填写邀请码";
    _invateCodeView.inputTextField.keyboardType = UIKeyboardTypeASCIICapable;
    [_invateCodeView.inputTextField addTarget:self action:@selector(rigisterLengthCount) forControlEvents:UIControlEventEditingChanged];
    [_baseScrollView addSubview:_invateCodeView];
    
    _registerBtton = [UIButton createTextButtonWithFrame:RECT(40+ScreenWidth, GETY(_invateCodeView.frame)+54, ScreenWidth-80, 50) bgColor:colorWithHexString(@"#ebebeb") textColor:[UIColor whiteColor] font:14 bold:YES title:@"注册"];
    [_registerBtton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_registerBtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerBtton.tag = 500;
    _registerBtton.layer.cornerRadius = 5;
    _registerBtton.layer.masksToBounds = YES;
    _registerBtton.userInteractionEnabled = NO;
    [_baseScrollView addSubview:_registerBtton];
    
    UILabel* tipLB = [UILabel new];
    tipLB.text = @"点击注册代表您已阅读并接受";
    tipLB.textColor = Color4D;
    tipLB.font = [UIFont systemFontOfSize:14];
    [_baseScrollView addSubview:tipLB];
    [tipLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_registerBtton);
        make.top.equalTo(_registerBtton.mas_bottom).offset(10);
    }];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"使用协议" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoWebView) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:ColorBlue forState:UIControlStateNormal];
    [_baseScrollView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipLB.mas_right);
        make.centerY.equalTo(tipLB);
    }];
}

- (void)gotoWebView {
    WebViewController* vc = [WebViewController new];
    vc.webTitle = @"用户协议";
    vc.url = @"http://apifml.manggeek.com/agreement.html";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 数据请求相关
- (void)doResuestToGetCode {
    if (![_phoneNumView.inputTextField.text isValidMobile]) {
        [self showToastHUD:@"请输入正确的邮箱"];
        return;
    }
    [self getEmail];
}
#pragma mark 相关事件处理
- (void)loginBtnClick:(UIButton *)sender {
    _isRes = NO;
    switch (sender.tag) {
        case 100:
        {
            [UIView animateWithDuration:.3 animations:^{
                _itemImageView.frame =RECT(ScreenWidth/4.0-10, FITGEIGHT-8, 20, 10);
            }];
            [_baseScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 200:
        {
            _isRes = YES;
            [UIView animateWithDuration:.3 animations:^{
                _itemImageView.frame =RECT(ScreenWidth/4.0*3-10, FITGEIGHT-8, 20, 10);
            }];
             [_baseScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        }
            break;
        case 300:
        {
            //登录按钮点击
            NSString* str;
            //            [self showToastHUD:@"点击注册了"];
            if (_userInputView.inputTextField.text == nil || _userInputView.inputTextField.text.length == 0) {
                str = @"请输入邮箱";
            } else if (_passwordInputView.inputTextField.text.length < 4) {
                str = @"请输入密码";
            }
            if (str) {
                [self showToastHUD:str];
            } else {
                [self dologin];
            }

        }
            break;
        case 400:
        { //自动登录
            if (sender.selected) {
                [sender setImage:IMAGE(@"icon_unselect") forState:UIControlStateNormal];
            }else {
                [sender setImage:IMAGE(@"icon_select") forState:UIControlStateNormal];
            }
            sender.selected = !sender.selected;
        }
            break;
        case 500:
        {
            //注册按钮点击
            NSString* str;
            if (_nickNameView.inputTextField.text.length==0) {
                str = @"请设置昵称";
                [self showToastHUD:str];
                return;
            }
            if (![_phoneNumView.inputTextField.text isValidMobile]) {
                str = @"请输入正确的手机号码";
                [self showToastHUD:str];
                return;
            }
            if (_codeView.inputTextField.text.length < 4) {
                str = @"请输入正确的验证码";
                [self showToastHUD:str];
                return;
            }
            if (![_passwordView.inputTextField.text isEqualToString:_surePasswordView.inputTextField.text]) {
                str = @"两次输入的密码不一致";
                [self showToastHUD:str];
                return;
            }
            if (_invateCodeView.inputTextField.text.length < 1) {
                str = @"请输入邀请码";
                [self showToastHUD:str];
                return;
            }
         
            [self doRes];
            
        }
            break;
        default:
            break;
    }
}

- (void)dologin {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = _userInputView.inputTextField.text;
    dict[@"password"] = _passwordInputView.inputTextField.text;
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/login.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            UIButton* btn = [self.view viewWithTag:400];
            if (btn.selected) {
                [[NSUserDefaults standardUserDefaults] setObject:@"isLogin" forKey:@"isLogin"];
            }
            if ([responseMessage.bussinessData[@"isAnswer"] isEqualToString:@"y"]) {
                [[UserSingle sharedUser] setLoginInfo:responseMessage.bussinessData];
                [UIApplication sharedApplication].delegate.window.rootViewController = [[MainViewController alloc]init];
            }else {
                [[UserSingle sharedUser] setInfo:responseMessage.bussinessData login:YES];
                AnswerViewController *vc = [[AnswerViewController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
    }];
}

- (void)doRes {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"email"] = _phoneNumView.inputTextField.text;
    dict[@"password"] = _passwordView.inputTextField.text;
    dict[@"emailCode"] = _codeView.inputTextField.text;
    dict[@"inviteCode"] = _invateCodeView.inputTextField.text;
    dict[@"nickName"] = _nickNameView.inputTextField.text;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/register.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [[UserSingle sharedUser] setInfo:responseMessage.bussinessData login:NO];
            AnswerViewController *vc = [[AnswerViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
}

- (void)getEmail {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = _phoneNumView.inputTextField.text;
    dict[@"type"] = @"signup";
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

- (void)forgetPassword {
    FindPswViewController *findVc = [[FindPswViewController alloc]init];
    findVc.type = FMLPasswordTypeLogin;
    findVc.CanPopRoot = YES;
    [self.navigationController pushViewController:findVc animated:YES];
}
/**
 *   登录按钮颜色变化
 **/
- (void)userOrPasswordLengthCount {
    if (_userInputView.inputTextField.text.length!=0&&_passwordInputView.inputTextField.text.length!=0) {
        _loginButton.userInteractionEnabled = YES;
        [_loginButton setBackgroundColor:ColorBlue];
    }else {
        _loginButton.userInteractionEnabled = NO;
        [_loginButton setBackgroundColor:ColorGray];
    }
}


/**
 *   注册按钮颜色变化
 **/
- (void)rigisterLengthCount {
    if (_phoneNumView.inputTextField.text.length!=0) {
        _registerBtton.userInteractionEnabled = YES;
        [_registerBtton setBackgroundColor:ColorBlue];
    }else {
        _registerBtton.userInteractionEnabled = NO;
        [_registerBtton setBackgroundColor:ColorGray];
    }
}


@end
