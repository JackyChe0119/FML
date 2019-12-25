//
//  CurrencyDetailViewController.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "CurrencyDetailViewController.h"
#import "CurrenncyTopView.h"
#import "CoinMiddleView.h"
#import "CurrencyBuyViewController.h"
#import "FMLAlertView.h"
#import "WebViewController.h"
#import "RealNameViewController.h"
#import "BindPhoneViewController.h"
#define isIPhoneX     (ScreenWidth == 375.f && ScreenHeight == 812.f)
@interface CurrencyDetailViewController ()

@property (nonatomic, strong) CurrenncyTopView* topView;
@property (nonatomic, strong) CoinMiddleView*   middleView;
@property (nonatomic, strong) UIScrollView*     scrollView;
@property (nonatomic, strong) UILabel*          content;
@property (nonatomic, strong) UIView*           contentView;
@property (nonatomic, copy)   NSString*         rule;
@property (nonatomic, copy)   NSDictionary*     dict;

@end

@implementation CurrencyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self layoutScrollView];
    [self bottomView];
    
    [self currencyDetail];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)setUI {
    
    _topView = [[CurrenncyTopView alloc] initWithFrame:CGRectZero];
    [_topView.leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topView];
    
}

- (void)layoutScrollView {
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight - 50 - (isIPhoneX ? 34 : 0))];
    _scrollView.contentInset = UIEdgeInsetsMake(BOTTOM(_topView) - NavHeight, 0, 0, 0);
    _scrollView.clipsToBounds = YES;
    [self.view addSubview:_scrollView];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, BOTTOM(_topView) - NavHeight, ScreenWidth, 0)];
    view.backgroundColor = ColorWhite;
    _contentView = view;
    [_scrollView addSubview:view];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(20, BOTTOM(_middleView) + 10, 100, 40)];
    [button setTitle:@"  规则说明（锁仓）" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"icon_tip"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(alertRule) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [button setTitleColor:ColorBlue forState:UIControlStateNormal];
    [button sizeToFit];
    [view addSubview:button];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, BOTTOM(button) + 35, 100, 40)];
    label.text = @"代币介绍";
    label.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    [label sizeToFit];
    [view addSubview:label];
    
    UIButton* lookBook = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    [lookBook setTitle:@"白皮书抢先看  " forState:UIControlStateNormal];
    [lookBook setImage:[UIImage imageNamed:@"icon_right"] forState:UIControlStateNormal];
    [lookBook addTarget:self action:@selector(lookWebView) forControlEvents:UIControlEventTouchUpInside];
    [lookBook setTitleColor:colorWithHexString(@"848693") forState:UIControlStateNormal];
    lookBook.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [lookBook sizeToFit];
    [lookBook setTitleEdgeInsets:UIEdgeInsetsMake(0, -lookBook.imageView.frame.size.width, 0, lookBook.imageView.frame.size.width)];
    [lookBook setImageEdgeInsets:UIEdgeInsetsMake(0, lookBook.titleLabel.bounds.size.width, 0, -lookBook.titleLabel.bounds.size.width)];
    lookBook.frame = CGRectMake(ScreenWidth - WIDTH(lookBook) - 10, TOP(label) + (HEIGHT(label) - HEIGHT(lookBook))/2, WIDTH(lookBook), HEIGHT(lookBook));
    [view addSubview:lookBook];
    
    _content = [[UILabel alloc] initWithFrame:CGRectMake(20, BOTTOM(lookBook) + 15, ScreenWidth - 40, 0)];
    _content.textColor = colorWithHexString(@"828599");
    _content.numberOfLines = 0;
    [view addSubview:_content];

    _content.text = @"";
    [self changeLineSpaceForLabel:_content WithSpace:5];
    view.frame = CGRectMake(0, 0, ScreenWidth, BOTTOM(_content) + 10);
    self.scrollView.contentSize = CGSizeMake(0, BOTTOM(view));
    
}

- (void)bottomView {
    CGFloat height = 50 + (isIPhoneX ? 34 : 0);
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - height, ScreenWidth, height)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIButton* bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 3, ScreenWidth - 60, 44)];
    bottomBtn.backgroundColor = colorWithHexString(@"506afa");
    bottomBtn.layer.cornerRadius = 6;
    [bottomBtn setTitle:@"购买" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bottomBtn];
}

- (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    NSString *labelText = label.text;
    if (!labelText) return;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary * dic =@{NSParagraphStyleAttributeName:paragraphStyle, NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone] };
    [attributedString setAttributes:dic range:NSMakeRange(0, attributedString.length)];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}

- (void)buy {
    if ([UserSingle sharedUser].isAuth==3&&[[UserSingle sharedUser].email containsString:@"@"]) {
        CurrencyBuyViewController* vc = [CurrencyBuyViewController new];
        vc.dict = _dict;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self showProgressHud];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/user_info.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [self hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [CommonToastHUD showTips:responseMessage.errorMessage];
            } else {
                [[UserSingle sharedUser] setLoginInfo:responseMessage.bussinessData];
                if ([UserSingle sharedUser].isAuth!=3||![[UserSingle sharedUser].email containsString:@"@"]) {
                    [self showAuthAlert];
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        CurrencyBuyViewController* vc = [CurrencyBuyViewController new];
                        vc.dict = _dict;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }
            }
        }];
    }
}
- (void)showAuthAlert {
    if (![[UserSingle sharedUser].email containsString:@"@"]) {
        [self showShadowViewWithColor:YES];
        FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"邮箱未绑定" msg:@"为了保证您的交易正常进行，请先去绑定邮箱"];
        
        if ([UserSingle sharedUser].isAuth != 1) {
            [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
                BindPhoneViewController* vc = [BindPhoneViewController new];
                vc.isEmail = YES;
                [self.navigationController pushViewController:vc animated:YES];
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
    
        [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
            RealNameViewController* vc = [RealNameViewController new];
            vc.noPush = YES;
            [self presentViewController:vc animated:YES completion:^{
            }];
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
}
- (void)alertRule {
    [self showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"规则" msg:self.rule];
    [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
        [self hiddenShadowView];
    }];
    [self.shadowView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.mas_equalTo(ScreenWidth * 0.8);
    }];
}

- (void)lookWebView {
    WebViewController* vc = [WebViewController new];
    vc.url = [ALIYUN_OSS_IMAGE_DOMAIN stringByAppendingString:_dict[@"currencyUrl"]];
    vc.webTitle = @"白皮书";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)currencyDetail {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"icoId"] = @(_icoId);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"currency_invest/detail.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            NSDictionary* dict = responseMessage.bussinessData;
            _dict = dict;
            [self.topView.currencyIcon sd_setImageWithURL:String(dict[@"logo"]).toUrl];
            self.topView.titleLabel.text = String(dict[@"currencyName"]);
            self.topView.currencyName.text = String(dict[@"currencyName"]);
            self.topView.rightStr = [NSString stringWithFormat:@"1%@\n= %@%@", dict[@"buyCurrencyName"],dict[@"ethRate"], dict[@"currencyName"]];
            self.topView.item1.rightStr = String(dict[@"totalNumber"]);
            self.topView.item2.rightStr = [String(dict[@"marketValue"]) stringByAppendingString:@" usdt"];
            self.topView.item3.rightStr = String(dict[@"dealNumber"]);
            self.topView.item4.rightStr = [String(dict[@"hourVolume"]) stringByAppendingString:@" usdt"];
            self.content.text = String(dict[@"currencyAbbreviation"]);
            
            [self changeLineSpaceForLabel:_content WithSpace:5];
            self.contentView.frame = CGRectMake(0, 0, ScreenWidth, BOTTOM(_content) + 10);
            self.scrollView.contentSize = CGSizeMake(0, BOTTOM(self.contentView));
            self.rule = String(dict[@"rule"]);
        }
    }];
}

@end
