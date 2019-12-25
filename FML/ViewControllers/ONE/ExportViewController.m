//
//  ExportViewController.m
//  FML
//
//  Created by 车杰 on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ExportViewController.h"
#import "InputView.h"
#import "CutsomPayView.h"
#import "FMLAlertView.h"
#import "SetPasswordViewController.h"
#import "RealNameViewController.h"
#import "RecordViewController.h"
#import "BindPhoneViewController.h"
@interface ExportViewController ()<UITextFieldDelegate>{
    BOOL isHaveDian;
}
@property (nonatomic,strong)InputView *addressInputView,*priceInputView,*remarkView;
@property (nonatomic,strong)CutsomPayView *payView;
@property (nonatomic, assign) CGFloat     mynumber;
@end

@implementation ExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"充值" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    [self navgationRightButtonImage:@"icon_ico_order"];
    [self layoutUI];
    [self currencyInfo];
}

- (void)navgationRightButtonClick {
    RecordViewController* record = [RecordViewController new];
    record.isIncome = YES;
    [self.navigationController pushViewController:record animated:YES];
}

- (void)layoutUI {
    
    _remarkView = [[InputView alloc]initWithFrame:RECT(0,10+NavHeight , ScreenWidth, 55)];
    _remarkView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_remarkView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
    [_remarkView addGestureRecognizer:longPre];
    
    _remarkView.rightTfPalceHold = @"";
    _remarkView.rightTf.userInteractionEnabled = NO;
    _remarkView.leftStr = @"充值地址";
    [self.view addSubview:_remarkView];
    
    _addressInputView = [[InputView alloc]initWithFrame:RECT(0,GETY(_remarkView.frame), ScreenWidth, 55)];
    _addressInputView.rightTfPalceHold = @"请输入钱包地址";
    _addressInputView.leftStr = @"用户转账钱包地址";
    _addressInputView.leftLabel.frame = RECT(15, 5, 140, 45);
    _addressInputView.rightTf.frame =RECT(GETX(_addressInputView.leftLabel.frame)+5, HEIGHT(_addressInputView)/2.0-15, WIDTH(_addressInputView)-GETX(_addressInputView.leftLabel.frame)-5-15, 30);
    [self.view addSubview:_addressInputView];
    
    _priceInputView = [[InputView alloc]initWithFrame:RECT(0,GETY(_addressInputView.frame) , ScreenWidth, 55)];
    _priceInputView.rightTfPalceHold = [NSString stringWithFormat:@"当前余额：%.2f", _number];
    _priceInputView.rightTf.delegate = self;
    _priceInputView.leftStr = @"转帐金额";
    _priceInputView.rightTf.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:_priceInputView];
    
    UIButton *rechargeBtton = [UIButton createTextButtonWithFrame:RECT(40, self.priceInputView.bottom + 55, ScreenWidth-80, 50) bgColor:ColorBlue textColor:[UIColor whiteColor] font:14 bold:YES title:@"确认充值"];
    [rechargeBtton addTarget:self action:@selector(transferBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rechargeBtton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeBtton.layer.cornerRadius = 5;
    rechargeBtton.layer.masksToBounds = YES;
    rechargeBtton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.view addSubview:rechargeBtton];
}
- (void)longPress {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _remarkView.rightLabel.text;
    [self showToastHUD:@"复制成功"];
}
- (void)tap {
    [self showToastHUD:@"长按可复制"];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    [self showToastHUD:@"亲，第一个数字不能为小数点"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            if ([textField.text isEqualToString:@"0"]) {
                if (single != '.') {
                    [self showToastHUD:@"亲，第一个数字不能为0"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    [self showToastHUD:@"亲，您已经输入过小数点了"];
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        [self showToastHUD:@"亲，您最多输入两位小数"];
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            [self showToastHUD:@"亲，您输入的格式不正确"];
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
    }
}
- (void)transferBtnClick {
    if (_addressInputView.rightTf.text.length == 0) {
        [self showToastHUD:_addressInputView.rightTf.placeholder];
        return;
    }
    if (_priceInputView.rightTf.text.length == 0) {
        [self showToastHUD:@"请输入转账数量"];
        return;
    }
    if ([_priceInputView.rightTf.text doubleValue]<=0) {
        [self showToastHUD:@"转账金额需大于零"];
        return;
    }
    if (![UserSingle sharedUser].isPayPwd) {
        [self showAlert];
        return;
    }
    
    if ([UserSingle sharedUser].isAuth != 3||![[UserSingle sharedUser].email containsString:@"@"]) {
        [self showAuthAlert];
        return;
    }
    [_addressInputView.rightTf resignFirstResponder];
    [_priceInputView.rightTf resignFirstResponder];
    [_remarkView.rightTf resignFirstResponder];
    [self showShadowViewWithColor:YES];
    if (!_payView) {
        __weak typeof(self)weakSelf = self;
        _payView = [[CutsomPayView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 420)];
        [MainWindow addSubview:_payView];
        [UIView animateWithDuration:.3 animations:^{
            _payView.frame = RECT(0, ScreenHeight-420, ScreenWidth, 420);
        }];
        NSString* s = [NSString stringWithFormat:@"%@%@" ,_priceInputView.rightTf.text ,_currencyName];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:s];
        UIFont *font2 = [UIFont boldSystemFontOfSize:15];
        [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(s.length-_currencyName.length,_currencyName.length)];
        _payView.priceLabel.attributedText = str;
        _payView.payBlock = ^(NSInteger index) {
            if (index==1) {
                //取消
                [weakSelf hiddenPayView:NO];
            }else if(index==2){
                //支付
                [weakSelf export];
            }else if (index==3) {
                [weakSelf hiddenPayView:NO];
                [weakSelf hiddenShadowView];
                FindPswViewController* vc = [FindPswViewController new];
                vc.type = FMLPasswordTypeChangeBuy;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index==4) {
                //                [weakSelf export];
                [weakSelf hiddenPayView:YES];
            }else if (index==5) {
                [weakSelf export];
            }
        };
    }
}
- (void)hiddenPayView:(BOOL)dismiss {
    [UIView animateWithDuration:.3 animations:^{
        self.payView.frame = RECT(0, ScreenHeight, ScreenWidth, 420);
    } completion:^(BOOL finished) {
        [_payView removeFromSuperview];
        _payView = nil;
        [self hiddenShadowView];
        if (dismiss) {
            [self navgationLeftButtonClick];
        }
    }];
}

- (void)navgationLeftButtonClick {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)showAlert {
    [self showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"支付密码" msg:@"您还未设置支付密码，请前往设置密码！"];
    [alertView addBtn:@"确定" titleColor:ColorGrayText action:^{
        SetPasswordViewController* vc = [SetPasswordViewController new];
        vc.type = FMLPasswordTYPESetNewBuyNoPush;
        [self presentViewController:vc animated:YES completion:^{
            
        }];
        [self hiddenShadowView];
    }];
    [alertView addBtn:@"取消" titleColor:ColorBlue action:^{
        [self hiddenShadowView];
    }];
    [self.shadowView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.mas_equalTo(ScreenWidth * 0.8);
    }];
}

- (void)showAuthAlert {
    if (![[UserSingle sharedUser].email containsString:@"@"]) {
        [self showShadowViewWithColor:YES];
        FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"邮箱未绑定" msg:@"为了保证您的交易正常进行，请先去绑定邮箱"];
        [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
            BindPhoneViewController* vc = [BindPhoneViewController new];
            vc.isEmail = YES;
            [self.navigationController pushViewController:vc animated:YES];
            [self hiddenShadowView];
        }];
        [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
            [self hiddenShadowView];
        }];
        [self.shadowView addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.shadowView);
            make.width.mas_equalTo(ScreenWidth * 0.8);
        }];
        return;
    }

    NSString *str;
    switch ([UserSingle sharedUser].isAuth) {
        case 0:
            str = @"您还未实名认证，请前往认证！";
            break;
        case 1:
            str = @"您的身份还在认证中！";
            break;
        case 2:
            str = @"实名认证被拒绝，请前往重新认证！";
            break;
        default:
            break;
    }
    [self showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"实名认证" msg:str];
    
    if ([UserSingle sharedUser].isAuth != 1) {
        [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
            RealNameViewController* vc = [RealNameViewController new];
            vc.noPush = YES;
            [self presentViewController:vc animated:YES completion:^{
            }];
            [self hiddenShadowView];
        }];
    }
    [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
        [self hiddenShadowView];
    }];
    [self.shadowView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.mas_equalTo(ScreenWidth * 0.8);
    }];
}


- (void)export {
 
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"sysCurrencyId"] = _currencyId;
    dict[@"walletAddress"] = _addressInputView.rightTf.text;
    dict[@"number"] = _priceInputView.rightTf.text;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"recharge/add_recharge.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            self.payView.pswView.unitField.text = @"";
        } else {
            [_payView createPaystatusView];
            NSString* s = @" 已提交！\n请耐心等待后台审核";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:s];
            [str addAttribute:NSFontAttributeName value:FONT(19) range:NSMakeRange(0,4)];
            [str addAttribute:NSFontAttributeName value:FONT(16) range:NSMakeRange(4,s.length - 4)];
            _payView.stausView.statusLabel.attributedText = str;
        }
    }];
}

- (void)currencyInfo {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"currencyId"] = _currencyId;
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"wallet_card/currency_info.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self navgationLeftButtonClick];
        } else {
            _mynumber = String(responseMessage.bussinessData[@"number"]).floatValue;
            _priceInputView.rightTfPalceHold = [NSString stringWithFormat:@"当前余额：%.2f", _mynumber];
            if (responseMessage.bussinessData[@"address"]) {
                _remarkView.rightTf.hidden = YES;
                _remarkView.rightStr =  responseMessage.bussinessData[@"address"];
       
            }
        }
    }];
}
@end
