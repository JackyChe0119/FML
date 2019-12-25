//
//  UpdateViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/7.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UpdateViewController.h"
#import "FMLAlertView.h"
#import "RealNameViewController.h"
#import "ExportViewController.h"
#import "QRCodeViewController.h"
#import "BindPhoneViewController.h"
@interface UpdateViewController ()
@end

@implementation UpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
}
- (void)layoutUI {
    
    UIImageView *BGImageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"iocn_-interstellar_bg"];
    [self.view addSubview:BGImageView];
    
    UIImageView *middleImageView = [UIImageView createImageViewWithFrame:RECT(ScreenWidth/2.0-80, (ScreenHeight)/2.0-80, 160, 160) imageName:@"iocn_-interstellar"];
    [self.view addSubview:middleImageView];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:17 isBold:YES text:@"节点升级" textColor:[UIColor whiteColor] superView:self.view];
    
    UIButton *_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:backUp_wihte];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    if (self.type==1) {
        UIImageView *stateImageView = [UIImageView createImageViewWithFrame:RECT(ScreenWidth/2.0-40, (ScreenHeight)/2.0-40, 80, 80) imageName:@"icon_update_faile"];
        stateImageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:stateImageView];
        
        UILabel *tipLabel = [UILabel new];
        [tipLabel rect:RECT(30,CGRectGetMinY(stateImageView.frame)-140 ,ScreenWidth-60, 20) aligment:Center font:15 isBold:YES text:@"很遗憾! 升级失败" textColor:[UIColor whiteColor] superView:self.view];
        
        UILabel *priceLabel = [UILabel new];
        [priceLabel rect:RECT(30, CGRectGetMinY(stateImageView.frame)-100, ScreenWidth-180, 20) aligment:Right font:11 isBold:YES text:@"" textColor:[UIColor whiteColor] superView:self.view];
        NSString *value = [NSString stringWithFormat:@"升级还需算力 %.2f FML",[_result[@"amountAcount"] doubleValue]];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:value];
        [str addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"#979797") range:NSMakeRange(0,6)];
        priceLabel.attributedText = str;
        
        UIButton *rechargeButton = [UIButton createTextButtonWithFrame:RECT(GETX(priceLabel.frame)+10, CGRectGetMinY(stateImageView.frame)-101, 75, 22) bgColor:[UIColor clearColor] textColor:[UIColor whiteColor] font:10 bold:YES title:@"如何获取算力"];
        rechargeButton.layer.cornerRadius = 1;
        rechargeButton.layer.borderWidth = .5;
        [rechargeButton addTarget:self action:@selector(rechargrButtonClick) forControlEvents:UIControlEventTouchUpInside];
        rechargeButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [self.view addSubview:rechargeButton];
        
        
        UILabel *NodeLabel = [UILabel new];
        [NodeLabel rect:RECT(30, CGRectGetMinY(stateImageView.frame)-60, ScreenWidth-60, 20) aligment:Center font:11 isBold:YES text:@"" textColor:[UIColor whiteColor] superView:self.view];
        NSString *strVal = [NSString stringWithFormat:@"%ld",[_result[@"nodeAcount"] integerValue]];
        NSString *value2 = [NSString stringWithFormat:@"普通节点还需要 %@ 个 拓展节点,获取更多收益",strVal];
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:value2];
        [str2 addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"#979797") range:NSMakeRange(0,7)];
        [str2 addAttribute:NSForegroundColorAttributeName value:colorWithHexString(@"#979797") range:NSMakeRange(strVal.length+9,1)];
        [str2 addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(11+strVal.length,value2.length-11-strVal.length)];
        NodeLabel.attributedText = str2;
        NodeLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(howToGetNode)];
        [NodeLabel addGestureRecognizer:tap];
    }else {
        UIImageView *stateImageView = [UIImageView createImageViewWithFrame:RECT(ScreenWidth/2.0-50, (ScreenHeight)/2.0-50, 100, 100) imageName:@"icon_super_node"];
        stateImageView.contentMode = UIViewContentModeCenter;
        [self.view addSubview:stateImageView];
        
        UILabel *srateLabel = [UILabel new];
        [srateLabel rect:RECT(30,CGRectGetMinY(stateImageView.frame)-90 ,ScreenWidth-60, 40) aligment:Center font:32 isBold:YES text:_result[@"superioritName"] textColor:[UIColor whiteColor] superView:self.view];
        
        UILabel *tipLabel = [UILabel new];
        [tipLabel rect:RECT(30,CGRectGetMinY(stateImageView.frame)-120 ,ScreenWidth-60, 20) aligment:Center font:15 isBold:YES text:@"恭喜您！升级为" textColor:[UIColor whiteColor] superView:self.view];
        
        UIImageView *infoImageView = [UIImageView createImageViewWithFrame:RECT(40, GETY(stateImageView.frame)+40, ScreenWidth-70, 160) imageName:@"icon_supernodebg"];
        [self.view addSubview:infoImageView];
        
        UILabel *Label1 = [UILabel new];
        [Label1 rect:RECT(20,10 ,WIDTH(infoImageView)-40, 30) aligment:Center font:15 isBold:YES text:[NSString stringWithFormat:@"%@特权",_result[@"superioritName"]] textColor:[UIColor whiteColor] superView:infoImageView];
        
        UILabel *Label2 = [UILabel new];
        [Label2 rect:RECT(20,55 ,WIDTH(infoImageView)-40, 30) aligment:Left font:12 isBold:YES text:[NSString stringWithFormat:@".特权一：子节点返佣比例提升至%.2f%%",[_result[@"superiorityOne"] doubleValue]*100] textColor:colorWithHexString(@"#979797")
           superView:infoImageView];
        Label2.numberOfLines = 2;

        
        UILabel *Label3 = [UILabel new];
        [Label3 rect:RECT(20,85 ,WIDTH(infoImageView)-40, 30) aligment:Left font:12 isBold:YES text:[NSString stringWithFormat:@".特权二：星系节点返佣比例提升至%.2f%%",[_result[@"superiorityTwo"] doubleValue]*100] textColor:colorWithHexString(@"#979797") superView:infoImageView];
        Label3.numberOfLines = 2;

        
        UILabel *Label4 = [UILabel new];
        [Label4 rect:RECT(20,115 ,WIDTH(infoImageView)-40, 30) aligment:Left font:12 isBold:YES text:[NSString stringWithFormat:@".特权三：自身节点进行量化投资收益提升至%.2f%%",[_result[@"superiorityThree"] doubleValue]*100] textColor:colorWithHexString(@"#979797") superView:infoImageView];
        Label4.numberOfLines = 2;
    }
}
- (void)howToGetNode {
    QRCodeViewController *vc  = [[QRCodeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rechargrButtonClick {
    if ([UserSingle sharedUser].isAuth==3&&[[UserSingle sharedUser].email containsString:@"@"]) {
        ExportViewController *vc = [[ExportViewController alloc]init];
        vc.currencyId = _result[@"fmlId"];
        vc.currencyName = @"FML";
        vc.number = 0;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentViewController:nav animated:YES completion:nil];
        return;
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
