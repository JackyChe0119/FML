//
//  FindPswViewController.m
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "FindPswViewController.h"
#import "customInputView.h"
#import "ReSetPswViewController.h"
@interface FindPswViewController ()
@property (nonatomic,strong)customInputView *phoneNumView,*codeView;
@property (nonatomic,strong)UIButton *nextButton;
@property (nonatomic,assign)BOOL isEmail;
@end

@implementation FindPswViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}


- (void)layoutUI {
    
    NSString* str;
    switch (_type) {
        case FMLPasswordTypeChangeBuy:
            str = @"找回支付密码";
            break;
        case FMLPasswordTypeLogin:
            str = @"找回登录密码";
            break;
        default:
            str = @"找回密码";
            break;
    }
    
    [self NavigationItemTitle:str Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    __weak typeof(self)weakSelf = self;
    
    _phoneNumView = [[customInputView alloc]initWithFrame:RECT(40,NavHeight , ScreenWidth-80, 55) style:0];
    _phoneNumView.leftImageStr = @"icon_phonenum";
    _phoneNumView.inputTextField.placeholder = @"请输入邮箱或手机号码";
//    _phoneNumView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_phoneNumView.inputTextField addTarget:self action:@selector(NextButtonLengthCount) forControlEvents:UIControlEventEditingChanged];
    _phoneNumView.leftImageHidden = YES;
    [self.view addSubview:_phoneNumView];
    
    _codeView = [[customInputView alloc]initWithFrame:RECT(40,GETY(_phoneNumView.frame) , ScreenWidth-80, 55) style:2];
    _codeView.leftImageStr = @"icon_checkcode";
    _codeView.inputTextField.placeholder = @"请输入验证码";
    _codeView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_codeView.inputTextField addTarget:self action:@selector(NextButtonLengthCount) forControlEvents:UIControlEventEditingChanged];
    _codeView.leftImageHidden = YES;
    _codeView.isBoard = YES;
    _codeView.inputViewBlcok = ^(NSInteger type) {
        if (type==2) { //获取验证码
            [weakSelf doResuestToGetCode];
        }
    };
    [self.view addSubview:_codeView];
    
    _nextButton = [UIButton createTextButtonWithFrame:RECT(40, GETY(_codeView.frame)+50, ScreenWidth-80, 50) bgColor:colorWithHexString(@"#ebebeb") textColor:[UIColor whiteColor] font:16 bold:YES title:@"确认"];
    [_nextButton addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextButton.tag = 500;
    _nextButton.layer.cornerRadius = 5;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.userInteractionEnabled = NO;
    [self.view addSubview:_nextButton];
}
#pragma mark 相关事件处理
- (void)NextButtonLengthCount {
    if (_phoneNumView.inputTextField.text.length!=0&&_codeView.inputTextField.text.length!=0) {
        _nextButton.userInteractionEnabled = YES;
        [_nextButton setBackgroundColor:ColorBlue];
    }else {
        _nextButton.userInteractionEnabled = NO;
        [_nextButton setBackgroundColor:ColorGray];
    }
}
- (void)nextBtnClick {
    if (self.isEmail) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        dict[@"email"] = _phoneNumView.inputTextField.text;
        dict[@"type"] = @"forget";
        dict[@"emailCode"] = _codeView.inputTextField.text;
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"email/check_email_code.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [self hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [self showToastHUD:responseMessage.errorMessage];
            } else {
                ReSetPswViewController *resteVC = [[ReSetPswViewController alloc]init];
                resteVC.phoneNum = _phoneNumView.inputTextField.text;
                resteVC.checkCode = _codeView.inputTextField.text;
                resteVC.type = _type;
                resteVC.CanPopRoot = _CanPopRoot;
                [self.navigationController pushViewController:resteVC animated:YES];
            }
        }];
    }else {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        dict[@"mobile"] = _phoneNumView.inputTextField.text;
        if (self.type== FMLPasswordTypeLogin) {
            dict[@"type"] = @"fetchPwd";
        }else if (self.type == FMLPasswordTypeChangeBuy) {
            dict[@"type"] = @"fetchPayPwd";
        } else {
            dict[@"type"] = @"";
        }
        dict[@"mobileCode"] = _codeView.inputTextField.text;
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"send/checkcode.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [self hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [self showToastHUD:responseMessage.errorMessage];
            } else {
                ReSetPswViewController *resteVC = [[ReSetPswViewController alloc]init];
                resteVC.phoneNum = _phoneNumView.inputTextField.text;
                resteVC.checkCode = _codeView.inputTextField.text;
                resteVC.type = _type;
                resteVC.CanPopRoot = _CanPopRoot;
                [self.navigationController pushViewController:resteVC animated:YES];
            }
        }];

    }
}
#pragma mark 数据请求
- (void)doResuestToGetCode {
    if (_phoneNumView.inputTextField.text.isValidMobile) {
        [self getMobile];
    }else {
        if (![_phoneNumView.inputTextField.text containsString:@"@"]) {
            [self showToastHUD:@"请输入正确的邮箱"];
            return;
        }
        [self getEmail];
    }
    
}
- (void)getMobile {
    self.isEmail = NO;
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = _phoneNumView.inputTextField.text;
    if (self.type== FMLPasswordTypeLogin) {
        dict[@"type"] = @"fetchPwd";
    }else if (self.type == FMLPasswordTypeChangeBuy) {
        dict[@"type"] = @"fetchPayPwd";
    } else {
        dict[@"type"] = @"";
    }
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"send/check_code.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showToastHUD:@"验证码已发送"];
            _codeView.needCount_down = YES;
        }
    }];

}
- (void)getEmail {
    [self showProgressHud];
    self.isEmail = YES;
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"email"] = _phoneNumView.inputTextField.text;
    dict[@"type"] = @"forget";
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"email/send_email.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showToastHUD:@"验证码已发送"];
            _codeView.needCount_down = YES;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
