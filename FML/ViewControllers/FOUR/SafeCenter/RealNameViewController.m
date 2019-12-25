//
//  RealNameViewController.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "RealNameViewController.h"
#import "RealNameView.h"
#import "RealNameAlertView.h"
#import "SelectPhotoManager.h"
#import "ChangeIconViewController.h"
#import "FMLTransitionDelegate.h"
#import "AliyunOSSEngine.h"
#import "CommonUtil.h"
#import "LeftLableTextField.h"
@interface RealNameViewController ()

@property (nonatomic, strong) RealNameView* positiveIDCard;
@property (nonatomic, strong) RealNameView* unPositiveIDCard;
@property (nonatomic, strong) RealNameView* handleIDcard;

@property (nonatomic, strong) SelectPhotoManager* photoManager;
@property (nonatomic, strong) FMLTransitionDelegate*    delegate;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic, strong) UIButton* commitBtn;
@property (nonatomic,strong)UIScrollView *baseScrollView;
@property (nonatomic,strong)LeftLableTextField *item1,*item2;
@property (nonatomic,strong) UIView *whiteView;
@end

@implementation RealNameViewController

- (SelectPhotoManager *)photoManager {
    if (!_photoManager) {
        _photoManager = [SelectPhotoManager new];
        _photoManager.superVC = self;
    }
    return _photoManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"实名认证" Color:Color1D];
    
    if (!_noPush) {
        [self navgationLeftButtonImage:backUp];
    } else {
        [self navgationRightButtonImage:@"close"];
        self.customNavView.height = self.customNavView.height + 44;
    }
    
    self.view.backgroundColor = RGB_A(248, 248, 248, 1);
    if ([UserSingle sharedUser].isAuth == 1 || [UserSingle sharedUser].isAuth == 3) {
        [self addScrollView];
        [self setView];
    }else {
        [self setfirstStep];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}
- (void)addScrollView {
    _baseScrollView = [[UIScrollView alloc]initWithFrame:RECT(0, GETY(self.customNavView.frame), ScreenWidth, ScreenHeight-GETY(self.customNavView.frame))];
    _baseScrollView.backgroundColor =ColorBg;
    _baseScrollView.showsVerticalScrollIndicator = NO;
    _baseScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:_baseScrollView];
}
- (void)setfirstStep {
    _whiteView = [UIView createViewWithFrame:RECT(0, GETY(self.customNavView.frame), ScreenWidth,ScreenHeight-GETY(self.customNavView.frame)) color:[UIColor whiteColor]];
    [self.view addSubview:_whiteView];
    
    _item1 = [LeftLableTextField new];
    _item1.backgroundColor = [UIColor whiteColor];
    _item1.frame = RECT(0, 20, ScreenWidth,64);
    _item1.titleLB.text = @"姓名";
    _item1.titleLB.textColor = Color1D;
    _item1.textField.textAlignment = NSTextAlignmentRight;
    _item1.textField.placeholder = @"请输入您的真实姓名";
    _item1.bottomLine.hidden = YES;
    [_whiteView addSubview:_item1];
    
    _item2 = [LeftLableTextField new];
    _item2.titleLB.text = @"身份证号";
    _item2.backgroundColor = [UIColor whiteColor];
    _item2.titleLB.textColor = Color1D;
    _item2.frame = RECT(0, 20+64, ScreenWidth, 64);
    _item2.textField.textAlignment = NSTextAlignmentRight;
    _item2.textField.keyboardType = UIKeyboardTypeASCIICapable;
    _item2.textField.placeholder = @"请输入您的身份证号";
    _item2.bottomLine.hidden = YES;
    [_whiteView addSubview:_item2];
    
    UIButton* commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = ColorBlue;
    commitBtn.frame = RECT(40, GETY(_item2.frame)+40, ScreenWidth-80, 50);
    commitBtn.layer.cornerRadius = 3;
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitRealNameAndCard) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:commitBtn];

}
- (void)commitRealNameAndCard {
    if (_item1.textField.text.length==0) {
        [self showToastHUD:@"真实姓名不能为空"];
        return;
    }
    if (_item1.textField.text.length>=20) {
        [self showToastHUD:@"姓名长度过长，请检查"];
        return;
    }
    if (![_item2.textField.text validateIDCardNumber]) {
        [self showToastHUD:@"身份证号出现错误，请检查"];
        return;
    }
    _whiteView.hidden = YES;
    [self addScrollView];
    [self setView];
}
- (void)navgationRightButtonClick {
    [self dismissViewControllerAnimated:YES completion:^{ }];
}
- (void)setView {
    
    __weak typeof(self) weakSelf = self;
    
    _positiveIDCard = [RealNameView new];
    _positiveIDCard.title.text = @"身份证正面照片";
    [_positiveIDCard.imageView sd_setImageWithURL:[UserSingle sharedUser].cardFront.toUrl placeholderImage:[UIImage imageNamed:@"positiveIDCard"]];
    _positiveIDCard.upImageBlock = ^(RealNameView *realView) {
        [weakSelf changeIcon:realView];
    };
    [_baseScrollView addSubview:_positiveIDCard];
    
    [_positiveIDCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_baseScrollView);
        make.top.equalTo(_baseScrollView).offset(20);
    }];
    if ([UserSingle sharedUser].cardFront.length > 15) {
        _unPositiveIDCard.imagePath = [[UserSingle sharedUser].cardFront componentsSeparatedByString:@"http://walletdlp.oss-cn-hongkong.aliyuncs.com/"][1];
    }
    
    _unPositiveIDCard = [RealNameView new];
    _unPositiveIDCard.title.text = @"身份证背面照片";
    [_unPositiveIDCard.imageView sd_setImageWithURL:[UserSingle sharedUser].cardBack.toUrl placeholderImage:[UIImage imageNamed:@"unPositiveIDCard"]];
    if ([UserSingle sharedUser].cardBack.length > 15) {
        _unPositiveIDCard.imagePath = [[UserSingle sharedUser].cardBack componentsSeparatedByString:@"http://walletdlp.oss-cn-hongkong.aliyuncs.com/"][1];
    }
    
    _unPositiveIDCard.upImageBlock = ^(RealNameView *realView) {
        [weakSelf changeIcon:realView];
    };
    [_baseScrollView addSubview:_unPositiveIDCard];
    [_unPositiveIDCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_baseScrollView);
        make.top.equalTo(_positiveIDCard.mas_bottom).offset(20);
    }];
    
    _handleIDcard = [RealNameView new];
    _handleIDcard.title.text = @"身份证手持照片";
//    _handleIDcard.baseImage = [UIImage imageNamed:@"handleIDcard"];
    [_handleIDcard.imageView sd_setImageWithURL:[UserSingle sharedUser].cardHand.toUrl placeholderImage:[UIImage imageNamed:@"handleIDcard"]];
    _handleIDcard.upImageBlock = ^(RealNameView *realView) {
        [weakSelf changeIcon:realView];
    };
    [_baseScrollView addSubview:_handleIDcard];
    [_handleIDcard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_baseScrollView);
        make.top.equalTo(_unPositiveIDCard.mas_bottom).offset(20);
    }];
    if ([UserSingle sharedUser].cardHand.length > 15) {
        _unPositiveIDCard.imagePath = [[UserSingle sharedUser].cardHand componentsSeparatedByString:@"ttp://walletdlp.oss-cn-hongkong.aliyuncs.com/"][1];
    }
    
    UIButton* commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = ColorBlue;
    commitBtn.layer.cornerRadius = 3;
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitRealImage) forControlEvents:UIControlEventTouchUpInside];
    [_baseScrollView addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_baseScrollView);
        make.width.equalTo(ScreenWidth-80);
        make.top.equalTo(_handleIDcard.mas_bottom).offset(40);
        make.height.mas_equalTo(50);
    }];
    _commitBtn = commitBtn;
    _commitBtn.hidden = ([UserSingle sharedUser].isAuth == 1 || [UserSingle sharedUser].isAuth == 3);
    [_baseScrollView setContentSize:CGSizeMake(ScreenWidth, 568)];
}

- (void)commitRealImage {
    
    for (RealNameView* realView in self.view.subviews) {
        if ([UserSingle sharedUser].isAuth==2) {
            if ([realView isKindOfClass:[RealNameView class]] && !realView.realImage) {
                [self showToastHUD:[@"请重新上传" stringByAppendingString:realView.title.text]];
                return;
            }
        }else {
            if ([realView isKindOfClass:[RealNameView class]] && !realView.realImage) {
                [self showToastHUD:[@"请上传" stringByAppendingString:realView.title.text]];
                return;
            }
        }
    }
    if (_positiveIDCard.imagePath==nil) {
        [self showToastHUD:@"身份证正面未上传或上传失败,请上传"];
        return;
    }
    if (_unPositiveIDCard.imagePath==nil) {
        [self showToastHUD:@"身份证反面未上传或上传失败,请上传"];
        return;
    }
    if (_handleIDcard.imagePath==nil) {
        [self showToastHUD:@"手持身份证未上传或上传失败,请上传"];
        return;
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"cardFront"] = _positiveIDCard.imagePath;
    dict[@"cardBack"] = _unPositiveIDCard.imagePath;
    dict[@"cardHand"] = _handleIDcard.imagePath;
    dict[@"realName"] = _item1.textField.text;
    dict[@"cardNumber"] = _item2.textField.text;
    [self showProgressHud];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/auth_card.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showShadowViewWithColor:YES];
            [[UserSingle sharedUser] login];
            RealNameAlertView* alertView = [[RealNameAlertView alloc] initWith:@"上传成功！"];
            self.commitBtn.hidden = YES;
            [self.shadowView addSubview:alertView];
            [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.shadowView);
                make.width.mas_equalTo(ScreenWidth * 0.8);
            }];
            alertView.closeHandler = ^{
                [self hiddenShadowView];
                if (_noPush) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            };
        }
    }];

}


- (void)changeIcon:(RealNameView *)realView {
    if ([UserSingle sharedUser].isAuth == 1 || [UserSingle sharedUser].isAuth == 3) {
        [self showShadowViewWithColor:YES];
        if (!_imageView) {
            _imageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@""];
            _imageView.contentMode =  UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yapInIamgeView)];
            _imageView.userInteractionEnabled = YES;
            [_imageView addGestureRecognizer:tap];
            _imageView.hidden = NO;
            _imageView.image = realView.imageView.image;
            [MainWindow addSubview:_imageView];
        }else {
            _imageView.hidden = NO;
            _imageView.image = realView.imageView.image;
            [MainWindow bringSubviewToFront:_imageView];
        }
        return;
    }
    __weak typeof(self) weakSelf = self;

    ChangeIconViewController* vc = [ChangeIconViewController new];
    self.delegate = [FMLTransitionDelegate shareInstance];
    self.delegate.height = 165.5;
    self.delegate.style = AnimationStyleBackScale;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.delegate;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    vc.selectPhotoType = ^(int index) {
        [weakSelf.photoManager selectPhotoWithType:index];
    };
    
    //选取照片成功
    self.photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY/MM/dd"];
        NSString *dateStr = [formatter stringFromDate:date];
        NSString* filePath = [NSString stringWithFormat:@"walletdlp/app/img/%@/photo_%@.png",dateStr, [weakSelf getNowTimeTimestamp2]];

        NSData *data = UIImagePNGRepresentation(image);
        
        [weakSelf showProgressHud];
        [AliyunOSSEngine uploadWithFilePath:filePath fileData:data progressBlock:^(long long bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"%lld", totalBytesExpectedToWrite);
        } callbackBlock:^(NSString *fileUrl) {
            NSLog(@"--------------%@", fileUrl);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (fileUrl) {
                    realView.realImage = image;
                    realView.imagePath = fileUrl;
                } else {
                    [weakSelf showToastHUD:@"上传失败"];
                }
                [weakSelf hiddenProgressHud];
            }];
        }];
    };
    
    self.photoManager.errorHandle = ^(NSString *error) {
        
    };
}
- (void)yapInIamgeView {
    _imageView.hidden = YES;
    [self hiddenShadowView];
}
- (NSString *)getNowTimeTimestamp2{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}
@end
