//
//  AgreementViewController.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AgreementViewController.h"
#import "FMLAlertView.h"

@interface AgreementViewController ()

@property (nonatomic, strong) UILabel*  content;
@property (nonatomic, strong) UIButton* commitbtn;
@property (nonatomic, strong) UIView*   bottomView;
@end

@implementation AgreementViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hiddenProgressHud];
}
- (void)setUI:(NSString *)rule {
    NSString* str;
    switch (_type) {
        case FMLAgreementTypeFYuncheck:
        case FMLAgreementTypeFYchecked:
            str = @"团队返佣机制";
            break;
        case FMLAgreementTypeFYXS:
            str = @"下属返佣机制";
            break;
        default:
            break;
    }
    [self NavigationItemTitle:str Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    self.view.backgroundColor = ColorWhite;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight - (_type == FMLAgreementTypeFYuncheck ? 50 : 0))];
    scrollView.backgroundColor = ColorWhite;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, ScreenWidth - 40, scrollView.height)];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentJustified;
    label.textColor = Color1D;
    label.font = [UIFont systemFontOfSize:16];
    label.text = rule;
    [label sizeToFit];
    [scrollView addSubview:label];
    
    if (_type != FMLAgreementTypeFYuncheck) {
        scrollView.contentSize = CGSizeMake(0, label.height + 10 + (IPhoneX ? 34 : 0));
    } else if (_type == FMLAgreementTypeFYuncheck) {
        
        UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbackground"]];
        imageView.frame = CGRectMake(20, label.bottom + 30, 15, 15);
        imageView.userInteractionEnabled = YES;
        [scrollView addSubview:imageView];
        
        UILabel* tip = [UILabel new];
        tip.textColor = Color4D;
        tip.font = [UIFont systemFontOfSize:14];
        tip.text = @"我已阅读团队返佣机制内容详情";
        [scrollView addSubview:tip];
        tip.frame = CGRectMake(imageView.right + 8, imageView.top, 300, imageView.height);
        
        UIButton* check = [UIButton buttonWithType:UIButtonTypeCustom];
        check.frame = CGRectMake(20, label.bottom + 30, 18, 18);
        [check setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [check setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        check.selected = NO;
        [check addTarget:self action:@selector(check:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:check];
        scrollView.contentSize = CGSizeMake(0, check.bottom + 20);
        
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"申请成为团队领导人" forState:UIControlStateNormal];
        btn.backgroundColor = ColorBlue;
        btn.frame = CGRectMake(0, ScreenHeight - 50 - TabBarHeight + 49, ScreenWidth, 50);
        [btn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        _commitbtn = btn;
        
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, btn.bottom, ScreenWidth, TabBarHeight - 49)];
        view.backgroundColor = ColorBlue;
        [self.view addSubview:view];
        _bottomView = view;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getSysParam];
  
}

- (void)commit {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];

    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"item/apply_item.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showShadowViewWithColor:YES];
            FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"提交申请" msg:@"您已提交申请，请耐心等待审核！"];
            [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
                [self hiddenShadowView];
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [self.shadowView addSubview:alertView];
            [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.shadowView);
                make.width.mas_equalTo(ScreenWidth * 0.8);
            }];
        }
    }];

}
- (void)getSysParam {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"type"] = @"withdrawCost";
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"sysParam/commiss_mechanism.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setUI:responseMessage.bussinessData[@"rule"]];
            });
        }
    }];
}
- (void)check:(UIButton *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        _commitbtn.backgroundColor = ColorBlue;
        _bottomView.backgroundColor = ColorBlue;
        _commitbtn.userInteractionEnabled = YES;
    } else {
        _commitbtn.backgroundColor = ColorGray;
        _bottomView.backgroundColor = ColorGray;
        _commitbtn.userInteractionEnabled = NO;
    }
}



@end
