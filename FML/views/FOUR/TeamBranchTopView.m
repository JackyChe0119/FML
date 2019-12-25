//
//  TeamBranchTopView.m
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "TeamBranchTopView.h"
#import "QRCodeView.h"
#import "AgreementViewController.h"

@implementation TeamBranchTopView {
    UILabel *    _peopleNum;
    UILabel *   _shouyiLabel;
    UILabel *   _emailLabel;
}

- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)state{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"iocn_zichantop"];
        [self setView:state];
    }
    return self;
}

- (void)setView:(NSInteger)state {
    
    UIImageView *imageView = [UIImageView createImageViewWithFrame:RECT(20, 25, 20, 20) imageName:@"icon_leader"];
    [self addSubview:imageView];
    
    UILabel* label1 = [[UILabel alloc]initWithFrame:RECT(55, 25, 100, 20)];
    label1.text = @"我是队长";
    label1.textColor = ColorWhite;
    label1.font = [UIFont systemFontOfSize:15];
    [self addSubview:label1];
    if (state==2) {
        label1.text = @"我是队员";
        imageView.image = IMAGE(@"icon_number");
    }
 
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12];
    [btn1 addTarget:self action:@selector(fenyon) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setTitle:@"查看返佣机制" forState:UIControlStateNormal];
    [self addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(label1);
    }];
    
    UIView* lineView = [UIView new];
    lineView.backgroundColor = ColorWhite;
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(btn1);
        make.top.equalTo(btn1.mas_bottom).offset(-5);
        make.height.mas_equalTo(0.5f);
    }];
    
    _peopleNum = [[UILabel alloc]initWithFrame:RECT(25, GETY(imageView.frame)+15, 100, 20)];
    _peopleNum.text = @"人数：0人";
    _peopleNum.textColor = ColorWhite;
    _peopleNum.font = [UIFont systemFontOfSize:13];
    _peopleNum.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_peopleNum];

    
    if (state==1) {
        _shouyiLabel = [[UILabel alloc]initWithFrame:RECT(ScreenWidth/2.0, _peopleNum.frame.origin.y, ScreenWidth/2.0-20, 20)];
        _shouyiLabel.text = @"收益102.0000FML";
        _shouyiLabel.textColor = ColorWhite;
        _shouyiLabel.textAlignment = NSTextAlignmentRight;
        _shouyiLabel.font = [UIFont boldSystemFontOfSize:13];
        _shouyiLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_shouyiLabel];
    }else {
        _emailLabel =[ [UILabel alloc]initWithFrame:RECT(25, GETY(_peopleNum.frame)+10, ScreenWidth-60, 20)];
        _emailLabel.text = @"队长：897432961@qq.com";
        _emailLabel.textColor = ColorWhite;
        _emailLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_emailLabel];
      
    }
}
- (void)fenyon {
    AgreementViewController* vc = [AgreementViewController new];
    vc.type = FMLAgreementTypeFYchecked;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
- (void)erCode {
    if (_teamId) {
        QRCodeView* qrView = [QRCodeView new];
        [qrView createQRCodeStr:_teamId teamName:@"我的团队"];
        [[UIApplication sharedApplication].delegate.window addSubview:qrView];
    } else {
        [(MJBaseViewController *)self.viewController showToastHUD:@"请稍后再试"];
    }
}
- (void)setNum:(NSString *)num {
    _num = num;
    _peopleNum.text = [NSString stringWithFormat:@"人数：%@",_num];
}
- (void)setShouyi:(NSString *)shouyi {
    _shouyi = shouyi;
    _shouyiLabel.text = [NSString stringWithFormat:@"收益：%@FML",_shouyi];
}
- (void)setEmail:(NSString *)email {
    _email = email;
    _emailLabel.text = [NSString stringWithFormat:@"队长：%@",_email];
}
- (void)setTeamId:(NSString *)teamId {
    _teamId = teamId;
}
@end
