//
//  TiXiViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/5.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "TiXiViewController.h"
#import "CutsomPayView.h"
#import "FindPswViewController.h"
@interface TiXiViewController ()<UITextFieldDelegate> {
    BOOL isHaveDian;
}
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)UITextField *numberTF;
@property (nonatomic,strong)CutsomPayView *payView;
@end

@implementation TiXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}
- (void)layoutUI {
    [self NavigationItemTitle:@"量化提利息" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight-SafeAreaBottomHeight-60)];
    _baseScrollView.backgroundColor = ColorBg;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_baseScrollView];
    
    
    UIImageView *TopImageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, 75) imageName:@"icon_top_imageView"];
    [_baseScrollView addSubview:TopImageView];
    
    UILabel  *label1 = [UILabel new];
    [label1 rect:RECT(20,15,100, 20) aligment:Left font:12 isBold:YES text:@"项目利息" textColor:[UIColor whiteColor] superView:_baseScrollView];
    
    UILabel  *label2 = [UILabel new];
    [label2 rect:RECT(20,37,ScreenWidth-40, 20) aligment:Left font:17 isBold:YES text:[NSString stringWithFormat:@"%.2f %@",[_resultDic[@"income"] doubleValue],_resultDic[@"payType"]] textColor:[UIColor whiteColor] superView:_baseScrollView];
    
    UIView *whiteView = [UIView createViewWithFrame:RECT(0, 75, ScreenWidth, 150) color:[UIColor whiteColor]];
    [_baseScrollView addSubview:whiteView];
    
    NSArray *array = @[@"结息周期",@"提现数量",@"到期时间"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel  *label = [UILabel new];
        [label rect:RECT(20,10*(idx+1)+40*idx,90, 30) aligment:Left font:12 isBold:YES text:array[idx] textColor:colorWithHexString(@"#7d7d7d") superView:whiteView];
        if (idx!=array.count-1) {
            UIView *lineView = [UIView createViewWithFrame:RECT(20, 50*(idx+1), ScreenWidth-40, .5) color:ColorBg];
            [whiteView addSubview:lineView];
        }
    }];
    
    UILabel  *timelabel = [UILabel new];
    [timelabel rect:RECT(ScreenWidth-120,10,100, 30) aligment:Right font:12 isBold:YES text:@"30天" textColor:colorWithHexString(@"#7d7d7d") superView:whiteView];
    NSString *type = _resultDic[@"payType"];
    UILabel  *danweilabel = [UILabel new];
    [danweilabel rect:RECT(ScreenWidth-25-8*type.length,60,(8*type.length)+5, 30) aligment:Right font:12 isBold:YES text:type textColor:colorWithHexString(@"#7d7d7d") superView:whiteView];
    
    _numberTF = [[UITextField alloc]initWithFrame:RECT(110,60 , ScreenWidth-135-8*type.length, 30)];
    _numberTF.borderStyle = 0;
    _numberTF.delegate =self;
    _numberTF.font = FONT(13);
    _numberTF.textAlignment = NSTextAlignmentRight;
    _numberTF.placeholder = @"请输入虚拟资产数量";
    [whiteView addSubview:_numberTF];
    
    UILabel  *datelabel = [UILabel new];
    [datelabel rect:RECT(ScreenWidth-120,110,100, 30) aligment:Right font:12 isBold:YES text:[DateUtil getDateStringFormString:_resultDic[@"endTime"] format:@"yyyy.MM.dd"] textColor:colorWithHexString(@"#7d7d7d") superView:whiteView];

    
    UIView *bgView = [UIView createViewWithFrame:RECT(20, ScreenHeight-SafeAreaBottomHeight-50, ScreenWidth-40, 40) color:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorWithHexString(@"#56a2fa").CGColor, (__bridge id)colorWithHexString(@"#5065f9").CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    [bgView.layer addSublayer:gradientLayer];
    
    UIButton *sure = [UIButton createTextButtonWithFrame:RECT(20, ScreenHeight-SafeAreaBottomHeight-50, ScreenWidth-40, 40)  bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] font:14 bold:NO title:@"确认提息"];
    [sure addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
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
    else {
        return YES;
    }
}
- (void)sureButtonClick {
    if (_numberTF.text.length==0) {
        [self showToastHUD:@"请输入提息金额"];
        return;
    }
    if ([_numberTF.text doubleValue]<=0) {
        [self showToastHUD:@"提息金额需大于零"];
        return;
    }
    if ([_numberTF.text doubleValue]>[_resultDic[@"income"] doubleValue]) {
        [self showToastHUD:@"提息金额不能大于利息总额"];
        return;
    }
    [self payPassword];
}
- (void)payPassword {
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
                [weakSelf tixi];
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
- (void)tixi {
        [self showProgressHud];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setValue:[NSNumber numberWithInteger:[_resultDic[@"id"] integerValue]] forKey:@"id"];
        [dict setValue:[NSNumber numberWithDouble:[_numberTF.text doubleValue]] forKey:@"number"];
       dict[@"payPwd"] = self.payView.pswView.unitField.text;
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"fdOrder/interest.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [self hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [self showToastHUD:responseMessage.errorMessage];
                [self hiddenPayView:NO];
            } else {
                [self showToastHUD:@"提息成功"];
                if (_tixiBlock) {
                    _tixiBlock();
                }
                [self hiddenPayView:YES];
            }
        }];
}
- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
