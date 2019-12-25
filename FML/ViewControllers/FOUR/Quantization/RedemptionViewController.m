//
//  RedemptionViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/9.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "RedemptionViewController.h"
#import "CutsomPayView.h"
#import "FindPswViewController.h"
@interface RedemptionViewController ()
@property (nonatomic,strong)CutsomPayView *payView;
@property (nonatomic,assign)float redeem;
@end

@implementation RedemptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"量化赎回" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    self.view.backgroundColor = colorWithHexString(@"#1a1a1a");
    if (!self.isFocus) {
        [self layoutUI];
    }else {
        [self getSysParam];
    }
}
- (void)getSysParam {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @"redeemCost";
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"sysParam/data.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            _redeem = String(responseMessage.bussinessData[@"content"]).floatValue;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutUI];
            });
        }
    }];
}
- (void)layoutUI {
    UIView *baseView = [UIView createViewWithFrame:RECT(20, 20+NavHeight, ScreenWidth-40, 200) color:[UIColor whiteColor]];
    [self.view addSubview:baseView];
    NSArray *array;
    NSArray *array2 ;
    if (self.isFocus) {
        array  = @[@"强制赎回",@"认购本金",@"结余利息",@"违约赎回",@"到账余额"];
        array2 = @[[NSString stringWithFormat:@"投资未到期 强制赎回违约 将扣除本息的%.2f%%",_redeem*100],[NSString stringWithFormat:@"%.2f %@",[_resultDic[@"amount"] doubleValue],_resultDic[@"payType"]],[NSString stringWithFormat:@"%.2f %@",[_resultDic[@"income"] doubleValue],_resultDic[@"payType"]],[NSString stringWithFormat:@"%.2f %@",([_resultDic[@"amount"] doubleValue]+[_resultDic[@"income"] doubleValue])*_redeem,_resultDic[@"payType"]],[NSString stringWithFormat:@"%.2f %@",([_resultDic[@"amount"] doubleValue]+[_resultDic[@"income"] doubleValue])-([_resultDic[@"amount"] doubleValue]+[_resultDic[@"income"] doubleValue])*_redeem,_resultDic[@"payType"]]];
    }else {
        array  = @[@"赎回",@"认购本金",@"结余利息",@"到账余额"];
        array2 = @[@"投资已到期",[NSString stringWithFormat:@"%.2f %@",[_resultDic[@"amount"] doubleValue],_resultDic[@"payType"]],[NSString stringWithFormat:@"%.2f %@",[_resultDic[@"income"] doubleValue],_resultDic[@"payType"]],[NSString stringWithFormat:@"%.2f %@",[_resultDic[@"amount"] doubleValue]+[_resultDic[@"income"] doubleValue],_resultDic[@"payType"]]];
    }
    baseView.frame = RECT(20, 20+NavHeight, ScreenWidth-40, 50*array.count);
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [UILabel new];
        [label rect:RECT(20, 10+50*idx, 80, 30) aligment:Left font:12 isBold:YES text:array[idx] textColor:Color1D superView:baseView];
        
        UIView *lineView = [UIView createViewWithFrame:RECT(20, 50*idx, ScreenWidth-80, .5) color:colorWithHexString(@"#f7f7f7")];
        [baseView addSubview:lineView];
        
        UILabel *label2 = [UILabel new];
        [label2 rect:RECT(100, 5+50*idx, ScreenWidth-160, 40) aligment:Right font:12 isBold:YES text:array2[idx] textColor:Color1D superView:baseView];
        label2.adjustsFontSizeToFitWidth = YES;
        if (idx==0) {
            if (self.isFocus) {
                label2.textColor = [UIColor redColor];
                label2.adjustsFontSizeToFitWidth = NO;
                label2.numberOfLines = 2;
            }else {
                label2.textColor = colorWithHexString(@"#9b9b9b");
            }
            label.textColor = colorWithHexString(@"#232323");
        }else if (idx==1||idx==2) {
            label.textColor = colorWithHexString(@"#c8c8c8");
            label2.textColor = colorWithHexString(@"#646464");
        }else {
            if (self.isFocus) {
                if (idx==3) {
                    label2.textColor = [UIColor redColor];
                    label.textColor = [UIColor redColor];
                }else {
                    label2.textColor = colorWithHexString(@"#232323");
                    label.textColor = colorWithHexString(@"#232323");
                }
            }else {
                label2.textColor = colorWithHexString(@"#232323");
                label.textColor = colorWithHexString(@"#232323");
            }
        }
    }];
    
    UIView *bgView = [UIView createViewWithFrame:RECT(20, GETY(baseView.frame)+20, ScreenWidth-40, 40) color:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorWithHexString(@"#56a2fa").CGColor, (__bridge id)colorWithHexString(@"#5065f9").CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    [bgView.layer addSublayer:gradientLayer];
    
    UIButton *sure = [UIButton createTextButtonWithFrame:RECT(20, GETY(baseView.frame)+20, ScreenWidth-40, 40)  bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] font:14 bold:NO title:@"全部赎回"];
    if (self.isFocus) {
        [sure setTitle:@"确认强制赎回！" forState:UIControlStateNormal];
    }
    [sure addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    
}
- (void)sureButtonClick {
    [self showShadowViewWithColor:YES];
    if (!_payView) {
        __weak typeof(self)weakSelf = self;
        _payView = [[CutsomPayView alloc]initWithFrame:RECT(0, ScreenHeight, ScreenWidth, 420)];
        _payView.typeInputView.rightTf.text = @"";
        [_payView createPasswordView];
        [MainWindow addSubview:_payView];
        [UIView animateWithDuration:.3 animations:^{
            _payView.frame = RECT(0, ScreenHeight-420, ScreenWidth, 420);
        }];
        _payView.priceLabel.text = @"";
        _payView.payBlock = ^(NSInteger index) {
            if (index==1) {
                //取消
                [weakSelf hiddenPayView:NO];
            }else if(index==2){
                //支付
                //                [weakSelf.payView createPasswordView];
            }else if (index==3) {
                [weakSelf hiddenPayView:NO];
                [weakSelf hiddenShadowView];
                FindPswViewController* vc = [FindPswViewController new];
                vc.type = FMLPasswordTypeChangeBuy;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else if (index==4) {
                [weakSelf hiddenPayView:YES];
            }else if (index==5) {
                [weakSelf Redemption];
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
- (void)Redemption {

    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithInteger:[_resultDic[@"id"] integerValue]] forKey:@"id"];
    dict[@"payPwd"] = self.payView.pswView.unitField.text;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"fdOrder/redeem.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self hiddenPayView:NO];
        } else {
            [self showToastHUD:@"赎回成功"];
            if (_RedemptionBlock) {
                _RedemptionBlock();
            }
            [self hiddenPayView:YES];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
