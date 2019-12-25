//
//  AliQRCodeUpdataViewController.m
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AliQRCodeUpdataViewController.h"
#import "RealNameView.h"
#import "RealNameAlertView.h"
#import "SelectPhotoManager.h"
#import "ChangeIconViewController.h"
#import "FMLTransitionDelegate.h"
#import "AliyunOSSEngine.h"
#import "CommonUtil.h"
#import "MyAliPayQRCodeViewController.h"
#import "UpLoadALiCloud.h"

@interface AliQRCodeUpdataViewController ()

@property (nonatomic, strong) RealNameView* positiveIDCard;

@property (nonatomic, strong) SelectPhotoManager* photoManager;
@property (nonatomic, strong) FMLTransitionDelegate*    delegate;

@end

@implementation AliQRCodeUpdataViewController

- (SelectPhotoManager *)photoManager {
    if (!_photoManager) {
        _photoManager = [SelectPhotoManager new];
        _photoManager.superVC = self;
        _photoManager.canEditPhoto = NO;
    }
    return _photoManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"支付宝二维码" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    self.view.backgroundColor = RGB_A(248, 248, 248, 1);
    [self setView];
}

- (void)setView {
    
    __weak typeof(self) weakSelf = self;
    
    UIImage* im = [UIImage imageNamed:@"icon_alipay_ps"];
    
    _positiveIDCard = [RealNameView new];
    _positiveIDCard.tag = 1001;
    _positiveIDCard.title.text = @"上传支付宝收款二维码";
    [self.view addSubview:_positiveIDCard];
    [_positiveIDCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-20);
        make.width.equalTo(self.view);
    }];
    _positiveIDCard.upImageBlock = ^(RealNameView *realView) {
        [weakSelf changeIcon:realView];
    };
    
    [_positiveIDCard.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(82);
        make.centerX.top.equalTo(_positiveIDCard);
    }];
    
    [_positiveIDCard.imageView sd_setImageWithURL:[UserSingle sharedUser].alipayPicture.toUrl placeholderImage:im completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if ([UserSingle sharedUser].alipayPicture.length > 10) {
            [_positiveIDCard.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(120 * image.size.height / image.size.width);
                make.centerX.top.equalTo(_positiveIDCard);
            }];
        }
    }];
    
    UIButton* commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commitBtn.backgroundColor = ColorBlue;
    commitBtn.layer.cornerRadius = 3;
    [commitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [commitBtn addTarget:self action:@selector(commitRealImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commitBtn];
    [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-40);
        make.left.equalTo(self.view).offset(40);
        make.bottom.equalTo(self.view.mas_bottom).offset(-70);
        make.height.mas_equalTo(50);
    }];
}

- (void)changeIcon:(RealNameView *)realView {
    
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
        NSString* filePath = [NSString stringWithFormat:@"walletdlp/app/img/%@/photo_%@",dateStr, [weakSelf getNowTimeTimestamp2]];
        
        NSData *data = UIImagePNGRepresentation(image);
        
        [weakSelf showProgressHud];

        [AliyunOSSEngine uploadWithFilePath:filePath fileData:data progressBlock:^(long long bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"%f", (CGFloat)(bytesWritten / totalBytesWritten));
        } callbackBlock:^(NSString *fileUrl) {
            NSLog(@"--------------%@", fileUrl);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                if (fileUrl) {
                    realView.realImage = image;
                    realView.imagePath = fileUrl;
                    [realView.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(120);
                        make.height.mas_equalTo(120 * image.size.height / image.size.width);
                        make.centerX.top.equalTo(realView);
                    }];
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

- (void)commitRealImage {
    
    for (RealNameView* realView in self.view.subviews) {
        if ([realView isKindOfClass:[RealNameView class]] && !realView.realImage) {
            [self showToastHUD:[@"请" stringByAppendingString:realView.title.text]];
            return;
        }
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"alipayPicture"] = _positiveIDCard.imagePath;
    
    [self showProgressHud];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/upolad_aliplay.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [self showShadowViewWithColor:YES];
            [[UserSingle sharedUser] login:^{
                RealNameAlertView* alertView = [[RealNameAlertView alloc] initWith:@"上传成功！"];
                [self.shadowView addSubview:alertView];
                [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.center.equalTo(self.shadowView);
                    make.width.mas_equalTo(ScreenWidth * 0.8);
                }];
                alertView.closeHandler = ^{
                    [self hiddenShadowView];
                    MyAliPayQRCodeViewController* vc = [MyAliPayQRCodeViewController new];
                    vc.image = _positiveIDCard.realImage;
                    [self.navigationController setViewControllers:@[self.navigationController.viewControllers[0], self.navigationController.viewControllers[1], vc] animated:YES];
                };
            }];
            
        }
    }];
    
}

- (NSString *)getNowTimeTimestamp2{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
    
}
@end
