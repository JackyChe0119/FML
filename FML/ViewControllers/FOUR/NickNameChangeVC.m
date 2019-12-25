//
//  NickNameChangeVC.m
//  FML
//
//  Created by 车杰 on 2018/9/3.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "NickNameChangeVC.h"
#import "ZMChineseConvert.h"
@interface NickNameChangeVC ()
@property (nonatomic,strong)UITextField *nickTF;
@end

@implementation NickNameChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"修改昵称" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    self.view.backgroundColor = ColorWhite;
    [self layoutUI];
}
- (void)layoutUI {
    if (!_nickTF) {
        _nickTF = [[UITextField alloc]initWithFrame:RECT(40, 10+NavHeight, ScreenWidth-110, 30)];
        _nickTF.placeholder = @"请输入昵称";
        _nickTF.textColor = Color4D;
        _nickTF.text = _nickName;
        _nickTF.font = FONT(14);
        [self.view addSubview:_nickTF];
    }
    UIButton *cancelBtn = [UIButton createimageButtonWithFrame:RECT(ScreenWidth-70, 10+NavHeight, 30, 30) imageName:@"iocn_delete_item"];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIView *lineView = [UIView createViewWithFrame:RECT(40, 45+NavHeight, ScreenWidth-80, .5) color:ColorLine];
    [self.view addSubview:lineView];
    
    UIButton* bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, NavHeight+80, ScreenWidth - 60, 44)];
    bottomBtn.backgroundColor = colorWithHexString(@"506afa");
    bottomBtn.layer.cornerRadius = 6;
    [bottomBtn setTitle:@"确认" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomBtn];
    
    
}

- (void)sureButtonClick {
    if (_nickTF.text.length==0) {
        [self showToastHUD:@"请输入昵称"];
        return;
    }
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"nickName"] = _nickTF.text;
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/update_user.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [UserSingle sharedUser].nickName = _nickTF.text;
            [self showToastHUD:@"修改成功"];
            if (_nickNameBlock) {
                _nickNameBlock(_nickTF.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
            //提前下
        }
    }];
}
- (void)cancelBtnClick{
    _nickTF.text = @"";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
