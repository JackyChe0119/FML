//
//  NoTeamView.m
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "NoTeamView.h"
#import "DIYScanViewController.h"
#import "Global.h"
#import "LBXScanViewStyle.h"
#import "AgreementViewController.h"
@implementation NoTeamView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setView];
    }
    return self;
}

- (void)setView {
    UIImage* image = [UIImage imageNamed:@"noteam"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[self imageResize:image andResizeTo:CGSizeMake(image.size.width / 2, image.size.height / 2)]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(self);
    }];
    
    UILabel* tip = [UILabel new];
    tip.textColor = ColorGrayText;
    tip.font = [UIFont systemFontOfSize:14];
    tip.textAlignment = NSTextAlignmentCenter;
    tip.text = @"您还未加入团队，赶快组建团队吧！";
    [self addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(imageView.mas_bottom).offset(10);
    }];
    
    UIButton* becomeLeader = [UIButton buttonWithType:UIButtonTypeCustom];
    [becomeLeader setTitle:@"成为团队领导人" forState:UIControlStateNormal];
    [becomeLeader setTitleColor:ColorBlue forState:UIControlStateNormal];
    [becomeLeader addTarget:self action:@selector(createTeam) forControlEvents:UIControlEventTouchUpInside];
    becomeLeader.layer.borderColor = ColorBlue.CGColor;
    becomeLeader.layer.cornerRadius = 4;
    becomeLeader.layer.borderWidth = 1;
    becomeLeader.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:becomeLeader];
    [becomeLeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(tip);
        make.top.equalTo(tip.mas_bottom).offset(25);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(40);
    }];
    
//    UIButton* joinTeam = [UIButton buttonWithType:UIButtonTypeCustom];
//    [joinTeam setTitle:@"扫码加入团队" forState:UIControlStateNormal];
//    [joinTeam addTarget:self action:@selector(joinTeam) forControlEvents:UIControlEventTouchUpInside];
//    joinTeam.backgroundColor = ColorBlue;
//    joinTeam.layer.cornerRadius = 4;
//    joinTeam.titleLabel.font = [UIFont systemFontOfSize:14];
//    [self addSubview:joinTeam];
//    [joinTeam mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self).offset(-30);
//        make.left.equalTo(becomeLeader.mas_right).offset(30);
//        make.top.width.equalTo(becomeLeader);
//        make.height.mas_equalTo(40);
//    }];
}

- (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize {
    CGFloat scale = [[UIScreen mainScreen]scale];
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)createTeam {
    if ([UserSingle sharedUser].isAuth !=3) {
        if (_authBlock) {
            _authBlock ();
        }
        return;
    }
    AgreementViewController* vc = [AgreementViewController new];
    vc.type = FMLAgreementTypeFYuncheck;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

- (void)joinTeam {
    DIYScanViewController *vc = [DIYScanViewController new];
    vc.style = [self InnerStyle];
    vc.isOpenInterestRect = YES;
    vc.libraryType = [Global sharedManager].libraryType;
    vc.scanCodeType = [Global sharedManager].scanCodeType;
    [self.viewController.navigationController pushViewController:vc animated:YES];

}

- (LBXScanViewStyle*)InnerStyle
{
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = NO;
    style.colorAngle = ColorBlue;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    style.notRecoginitonArea = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    return style;
}

@end
