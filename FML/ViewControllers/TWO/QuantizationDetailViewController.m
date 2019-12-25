//
//  QuantizationDetailViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/5.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "QuantizationDetailViewController.h"
#import "SubscriptionViewController.h"
#import "RuleViewController.h"
#import "FMLAlertView.h"
#import "RealNameViewController.h"
#import "BindPhoneViewController.h"
@interface QuantizationDetailViewController ()
@property (nonatomic,strong)UIScrollView *baseScrollView;
@end

@implementation QuantizationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)layoutUI {
    UIImageView *topImageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, 205-64+NavHeight) imageName:@"iocn_lianghua_top"];
    [self.view addSubview:topImageView];
    
   UIButton *_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:backUp_wihte];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:15 isBold:YES text:[NSString stringWithFormat:@"%@(%@)",_resultDic[@"title"],_resultDic[@"currencyType"]] textColor:[UIColor whiteColor] superView:self.view];
    titleLabel.numberOfLines = 2;
    
    UILabel *label1 = [UILabel new];
    [label1 rect:RECT(ScreenWidth/2.0-50, GETY(titleLabel.frame)+20, 100, 15) aligment:Center font:10 isBold:YES text:@"预期年化" textColor:colorWithHexString(@"#e1e1e1") superView:self.view];
    
    UILabel *precentlabel = [UILabel new];
    [precentlabel rect:RECT(ScreenWidth/2.0-100, GETY(label1.frame)+5, 200, 30) aligment:Center font:26 isBold:YES text:[NSString stringWithFormat:@"%.2f%%",[_resultDic[@"profitRate"] doubleValue]*100*12] textColor:colorWithHexString(@"#ffffff") superView:self.view];
    
    UILabel *label2 = [UILabel new];
    [label2 rect:RECT(15, GETY(precentlabel.frame)+10, (ScreenWidth-30)/3.0, 20) aligment:Left font:10 isBold:YES text:@"预期净值" textColor:colorWithHexString(@"#e1e1e1") superView:self.view];
    
    UILabel *label5 = [UILabel new];
    [label5 rect:RECT(15, GETY(label2.frame), (ScreenWidth-30)/3.0, 20) aligment:Left font:15 isBold:YES text:[NSString stringWithFormat:@"%.2f%@",[_resultDic[@"investRatio"] doubleValue],_resultDic[@"currencyType"]] textColor:colorWithHexString(@"#e1e1e1") superView:self.view];
    label5.adjustsFontSizeToFitWidth = YES;
    
    UILabel *label3 = [UILabel new];
    [label3 rect:RECT(15+(ScreenWidth-30)/3.0, GETY(precentlabel.frame)+10, (ScreenWidth-30)/3.0, 20) aligment:Center font:10 isBold:YES text:@"起购数量" textColor:colorWithHexString(@"#e1e1e1") superView:self.view];
    
    UILabel *label6 = [UILabel new];
    [label6 rect:RECT(15+(ScreenWidth-30)/3.0, GETY(label3.frame), (ScreenWidth-30)/3.0, 20) aligment:Center font:15 isBold:YES text:[NSString stringWithFormat:@"%.2f%@",[_resultDic[@"minAmount"] doubleValue],_resultDic[@"currencyType"]] textColor:colorWithHexString(@"#e1e1e1") superView:self.view];
    label6.adjustsFontSizeToFitWidth = YES;
    
    UILabel *label4 = [UILabel new];
    [label4 rect:RECT(15+(ScreenWidth-30)/3.0*2, GETY(precentlabel.frame)+10, (ScreenWidth-30)/3.0, 20) aligment:Right font:10 isBold:YES text:@"认购期限" textColor:colorWithHexString(@"#e1e1e1") superView:self.view];
    
    UILabel *label7 = [UILabel new];
    [label7 rect:RECT(15+(ScreenWidth-30)/3.0*2, GETY(label4.frame), (ScreenWidth-30)/3.0, 20) aligment:Right font:15 isBold:YES text:[NSString stringWithFormat:@"%ldDAY",[_resultDic[@"duration"] integerValue]] textColor:colorWithHexString(@"#e1e1e1") superView:self.view];
    label7.adjustsFontSizeToFitWidth = YES;
    
    
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, GETY(topImageView.frame), ScreenWidth, ScreenHeight-GETY(topImageView.frame)-SafeAreaBottomHeight-60)];
    _baseScrollView.backgroundColor = ColorBg;
    _baseScrollView.alwaysBounceVertical = YES;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_baseScrollView];
    
    UIImageView *tipImageView = [UIImageView createImageViewWithFrame:RECT(0, 10, ScreenWidth, 100) imageName:@"iocn_lianghua_middle"];
    [_baseScrollView addSubview:tipImageView];
    
    
    UIView *accTypeView1 = [UIView createViewWithFrame:RECT(0, GETY(tipImageView.frame)+10, ScreenWidth, 50) color:[UIColor whiteColor]];
    accTypeView1.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    accTypeView1.tag  = 100;
    [accTypeView1 addGestureRecognizer:tap];
    [_baseScrollView addSubview:accTypeView1];
    
    UILabel *label8 = [UILabel new];
    [label8 rect:RECT(15, 10, 100, 30) aligment:Left font:12 isBold:YES text:@"产品介绍" textColor:colorWithHexString(@"#7d7d7d") superView:accTypeView1];
    
    UIImageView *acctypeIamge1= [UIImageView createImageViewWithFrame:RECT(ScreenWidth-30, 10, 30, 30) imageName:@"icon_accesstype_blue"];
    acctypeIamge1.contentMode = UIViewContentModeCenter;
    [accTypeView1 addSubview:acctypeIamge1];
    
    
    UIView *accTypeView2 = [UIView createViewWithFrame:RECT(0, GETY(accTypeView1.frame), ScreenWidth, 50) color:[UIColor whiteColor]];
    accTypeView2.tag  = 200;
    accTypeView2.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [accTypeView2 addGestureRecognizer:tap2];
    [_baseScrollView addSubview:accTypeView2];
    
    UILabel *label9 = [UILabel new];
    [label9 rect:RECT(15, 10, 100, 30) aligment:Left font:12 isBold:YES text:@"电子认购合同" textColor:colorWithHexString(@"#7d7d7d") superView:accTypeView2];
    
    UIImageView *acctypeIamge2= [UIImageView createImageViewWithFrame:RECT(ScreenWidth-30, 10, 30, 30) imageName:@"icon_accesstype_blue"];
    acctypeIamge2.contentMode = UIViewContentModeCenter;
    [accTypeView2 addSubview:acctypeIamge2];
    
    UIView *lineView = [UIView createViewWithFrame:RECT(15, 49.5, ScreenWidth-30, .5) color:ColorLine];
    [accTypeView1 addSubview:lineView];
    
//    UIView *bottomView = [UIView createViewWithFrame:RECT(0, GETY(accTypeView2.frame)+10, ScreenWidth, 200) color:[UIColor whiteColor]];
//
//    [_baseScrollView addSubview:bottomView];
    
//    UILabel *label10 = [UILabel new];
//    [label10 rect:RECT(15, 20, 100, 30) aligment:Left font:12 isBold:YES text:@"认购准则" textColor:colorWithHexString(@"#7d7d7d") superView:bottomView];
//
//    UILabel *label11 = [UILabel new];
//    [label11 rect:RECT(15, GETY(label10.frame), ScreenWidth-30, 30) aligment:Left font:10 isBold:YES text:_resultDic[@"content"] textColor:colorWithHexString(@"#c8c8c8") superView:bottomView];
//    label11.numberOfLines = 0;
//    [label11 sizeToFit];
//
//    UILabel *label13 = [UILabel new];
//    [label13 rect:RECT(15, GETY(label11.frame)+10, 100, 30) aligment:Left font:12 isBold:YES text:@"赎回准则" textColor:colorWithHexString(@"#7d7d7d") superView:bottomView];
//
//    UILabel *label14 = [UILabel new];
//    [label14 rect:RECT(15, GETY(label13.frame), ScreenWidth-30, 30) aligment:Left font:10 isBold:YES text:_resultDic[@"reedmContent"] textColor:colorWithHexString(@"#c8c8c8") superView:bottomView];
//    label14.numberOfLines = 0;
//    [label14 sizeToFit];
    

    [_baseScrollView setContentSize:CGSizeMake(ScreenWidth, GETY(accTypeView1.frame)+10)];
    
    
    UIView *bgView = [UIView createViewWithFrame:RECT(20, ScreenHeight-SafeAreaBottomHeight-50, ScreenWidth-40, 40) color:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)colorWithHexString(@"#56a2fa").CGColor, (__bridge id)colorWithHexString(@"#5065f9").CGColor];
    gradientLayer.locations = @[@0.3, @0.5, @1.0];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    [bgView.layer addSublayer:gradientLayer];
    
    UIButton *sure = [UIButton createTextButtonWithFrame:RECT(20, ScreenHeight-SafeAreaBottomHeight-50, ScreenWidth-40, 40)  bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] font:14 bold:NO title:@"立即认购"];
    [sure addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sure];
    
}
- (void)tap:(UITapGestureRecognizer *)tap {
    RuleViewController *vc = [[RuleViewController alloc]init];
    if (tap.view.tag==100) {
        vc.navTitle = @"产品介绍";
        vc.url = _resultDic[@"ruleFile"];
    }else {
        vc.navTitle = @"电子认购合同";
        vc.url = _resultDic[@"contractFile"];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)sureButtonClick {
    if ([UserSingle sharedUser].isAuth==3&&[[UserSingle sharedUser].email containsString:@"@"]) {
        SubscriptionViewController *vc = [[SubscriptionViewController alloc]init];
        vc.resultDic = _resultDic;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self showAuthAlert];
     }
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
            [self presentViewController:vc animated:YES completion:^{}];
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
- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
