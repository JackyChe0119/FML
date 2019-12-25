//
//  ReSetPswViewController.m
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ReSetPswViewController.h"
#import "customInputView.h"
#import "loginViewController.h"

@interface ReSetPswViewController ()
@property (nonatomic,strong)customInputView *passwordView,*surePasswordView;
@property (nonatomic,strong)UIButton *nextButton;

@end

@implementation ReSetPswViewController

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
 
    _passwordView = [[customInputView alloc]initWithFrame:RECT(40,NavHeight , ScreenWidth-80, 55) style:0];
    _passwordView.leftImageStr = @"icon_phonenum";
    _passwordView.inputTextField.placeholder = @"请输入重置密码";
    _passwordView.inputTextField.keyboardType = _type == FMLPasswordTypeSetNewBuy ? UIKeyboardTypeNumberPad : UIKeyboardTypeASCIICapable;
    [_passwordView.inputTextField addTarget:self action:@selector(NextButtonLengthCount) forControlEvents:UIControlEventEditingChanged];
    _passwordView.inputTextField.secureTextEntry = YES;
    _passwordView.leftImageHidden = YES;
    [self.view addSubview:_passwordView];
    
    _surePasswordView = [[customInputView alloc]initWithFrame:RECT(40,GETY(_passwordView.frame) , ScreenWidth-80, 55) style:0];
    _surePasswordView.leftImageStr = @"icon_phonenum";
    _surePasswordView.inputTextField.placeholder = @"请再次确认密码";
    _surePasswordView.inputTextField.keyboardType = _type == FMLPasswordTypeSetNewBuy ? UIKeyboardTypeNumberPad : UIKeyboardTypeASCIICapable;
    _surePasswordView.inputTextField.secureTextEntry = YES;
    [_surePasswordView.inputTextField addTarget:self action:@selector(NextButtonLengthCount) forControlEvents:UIControlEventEditingChanged];
    _surePasswordView.leftImageHidden = YES;
    [self.view addSubview:_surePasswordView];
    
    _nextButton = [UIButton createTextButtonWithFrame:RECT(40, GETY(_surePasswordView.frame)+50, ScreenWidth-80, 50) bgColor:colorWithHexString(@"#ebebeb") textColor:[UIColor whiteColor] font:16 bold:YES title:@"确定"];
    [_nextButton addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextButton.tag = 500;
    _nextButton.layer.cornerRadius = 5;
    _nextButton.layer.masksToBounds = YES;
    _nextButton.userInteractionEnabled = NO;
    [self.view addSubview:_nextButton];
    
    if (_type == FMLPasswordTypeChangeBuy) {
        _passwordView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        _surePasswordView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
}
- (void)NextButtonLengthCount {
    if (_passwordView.inputTextField.text.length!=0&&_surePasswordView.inputTextField.text.length!=0) {
        _nextButton.userInteractionEnabled = YES;
        [_nextButton setBackgroundColor:ColorBlue];
    }else {
        _nextButton.userInteractionEnabled = NO;
        [_nextButton setBackgroundColor:ColorGray];
    }
}
- (void)nextBtnClick {
    if (_type == FMLPasswordTypeChangeBuy && _passwordView.inputTextField.text.length != 6) {
        [self showToastHUD:@"支付密码必须为6位数字，请重新输入"];
    }
    if (![_passwordView.inputTextField.text isEqualToString:_surePasswordView.inputTextField.text]) {
        [self showToastHUD:@"两次密码不一致，请重新输入"];
        return;
    }
//    if (!_phoneNum.isValidMobile) {
//        [self showToastHUD:@"请输入正确的手机号"];
//        return;
//    }
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"mobile"] = _phoneNum;
    dict[@"mobileCode"] = _checkCode;
    dict[@"newPwd"] = _passwordView.inputTextField.text;
    dict[@"comfirmPwd"] = _surePasswordView.inputTextField.text;
    if (self.type== FMLPasswordTypeLogin) {
        dict[@"type"] = @"fetchPwd";
    }else if (self.type == FMLPasswordTypeChangeBuy) {
        dict[@"type"] = @"fetchPayPwd";
    } else {
        dict[@"type"] = @"";
    }
    NSString* urlStr = _type == FMLPasswordTypeChangeBuy ? @"user/forget_pay_pwd.htm" : @"user/forget_pwd.htm";
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:urlStr.apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showToastHUD:@"重置成功"];
            if (_type == FMLPasswordTypeChangeBuy) {
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else if (_type == FMLPasswordTypeLogin) {
                if (self.CanPopRoot) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else {
                    [[UIApplication sharedApplication].delegate window].rootViewController = [[UINavigationController alloc]initWithRootViewController:[[loginViewController alloc]init]];
                }
            }
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
