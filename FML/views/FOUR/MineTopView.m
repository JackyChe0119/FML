//
//  MineTopView.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MineTopView.h"
#import "CommonUtil.h"
#import "RealNameViewController.h"

@interface MineTopView()

@property (nonatomic, strong) UILabel*  username;
@property (nonatomic, strong) UIImageView*  usericon;
@property (nonatomic, strong) UIButton* checkBtn;

@end

@implementation MineTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = ColorWhite;
        [self setView];
    }
    return self;
}

- (void)setView {
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, -StatusBarHeight, ScreenWidth, StatusBarHeight)];
    view.backgroundColor = ColorWhite;
    [self addSubview:view];
    self.clipsToBounds = NO;
    
    _username = [UILabel new];
    _username.text = [UserSingle sharedUser].nickName ? [UserSingle sharedUser].nickName : @"";
    _username.font = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
    [self addSubview:_username];
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(40);
    }];
    
    _usericon = [UIImageView new];
    _usericon.backgroundColor = [UIColor whiteColor];
    _usericon.layer.cornerRadius = 35;
    _usericon.layer.masksToBounds = YES;
    [_usericon sd_setImageWithURL:[UserSingle sharedUser].picture.toUrl placeholderImage:[UIImage imageNamed:@"icon_default"]];
    [self addSubview:_usericon];
    [_usericon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_username);
        make.right.equalTo(self).offset(-35);
        make.width.height.mas_equalTo(70);
    }];
    
    _checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _checkBtn.layer.borderWidth = 1;
    _checkBtn.layer.cornerRadius = 3;
    _checkBtn.layer.borderColor = RGB_A(192, 194, 209, 1).CGColor;
    _checkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_checkBtn setTitleColor:RGB_A(192, 194, 209, 1) forState:UIControlStateNormal];
    [self addSubview:_checkBtn];
    [_checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_username);
        make.top.equalTo(_username.mas_bottom).offset(10);
        make.width.mas_equalTo(55);
        make.height.mas_equalTo(27);
    }];
    if ([UserSingle sharedUser].isAuth==0) {
        [_checkBtn setTitle:@"未认证" forState:UIControlStateNormal];
    }else if ([UserSingle sharedUser].isAuth==1) {
        [_checkBtn setTitle:@"认证中" forState:UIControlStateNormal];
    }else if ([UserSingle sharedUser].isAuth==2) {
        [_checkBtn setTitle:@"未认证" forState:UIControlStateNormal];
    }else {
        [_checkBtn setTitle:@"已认证" forState:UIControlStateNormal];
    }
    [_checkBtn addTarget:self action:@selector(gotoRealNameVC) forControlEvents:UIControlEventTouchUpInside];
//    _checkBtn.userInteractionEnabled = NO;
}

- (void)reloadData {
    [_usericon sd_setImageWithURL:[UserSingle sharedUser].picture.toUrl placeholderImage:[UIImage imageNamed:@"icon_default"]];
    _username.text = [UserSingle sharedUser].nickName ? [UserSingle sharedUser].nickName : @"";
    if ([UserSingle sharedUser].isAuth==0) {
        [_checkBtn setTitle:@"未认证" forState:UIControlStateNormal];
    }else if ([UserSingle sharedUser].isAuth==1) {
        [_checkBtn setTitle:@"认证中" forState:UIControlStateNormal];
    }else if ([UserSingle sharedUser].isAuth==2) {
        [_checkBtn setTitle:@"未认证" forState:UIControlStateNormal];
    }else {
        [_checkBtn setTitle:@"已认证" forState:UIControlStateNormal];
    }
    _checkBtn.selected = [UserSingle sharedUser].isAuth == 3;
}

- (void)gotoRealNameVC {
    RealNameViewController *vc = [RealNameViewController new];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

@end
