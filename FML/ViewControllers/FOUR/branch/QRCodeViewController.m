//
//  QRCodeViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/7.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "QRCodeViewController.h"

@interface QRCodeViewController ()
@property (nonatomic,strong)UIImageView *qrCodeIamgeView;
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * str = [UserSingle sharedUser].userNo;
    if (str==nil) {
        [[UserSingle sharedUser] login:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self layoutUI];
            });
        }];
    }else {
        [self layoutUI];
    }
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
    [titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:17 isBold:YES text:@"邀请新节点" textColor:[UIColor whiteColor] superView:self.view];
    
    UIButton *_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:backUp_wihte];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
//    UIView *bgView = [UIView createViewWithFrame:RECT(ScreenWidth/2.0-75, (ScreenHeight-NavHeight)/2.0-100, 150, 150) color:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
//    [self.view addSubview:bgView];
    
    [self addQrcode];
    
    UIButton *saveButton = [UIButton createTextButtonWithFrame:RECT(40, ScreenHeight-70, ScreenWidth-80, 40) bgColor:[UIColor whiteColor] textColor:colorWithHexString(@"#1e2169") font:14 bold:YES title:@"保存二维码"];
    saveButton.layer.cornerRadius = 3;
    saveButton.layer.masksToBounds = YES;
    [saveButton addTarget:self action:@selector(saveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];

    
}
- (void)addQrcode {
    
    // 1.创建过滤器 -- 苹果没有将这个字符封装成常量
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.过滤器恢复默认设置
    [filter setDefaults];
    

    NSString *info = [NSString stringWithFormat:@"%@?userNo=%@",@"getView/register.htm".apifml,[UserSingle sharedUser].userNo];
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    // 4.获取输出的二维码
    
    UIView *bgView = [UIView createViewWithFrame:RECT(ScreenWidth/2.0-75, (ScreenHeight-NavHeight)/2.0-100, 150, 150) color:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
    [self.view addSubview:bgView];
    
    CIImage *outputImage = [filter outputImage];
    _qrCodeIamgeView= [UIImageView createImageViewWithFrame:RECT(5, 5, 140, 140) imageName:@""];
    _qrCodeIamgeView.layer.borderWidth = 5;
    _qrCodeIamgeView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:.3].CGColor;
    _qrCodeIamgeView.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:140];
    [bgView addSubview:_qrCodeIamgeView];
    
    UILabel *tipLabel = [UILabel new];
    [tipLabel rect:RECT(60, GETY(bgView.frame)+15, ScreenWidth-120, 50) aligment:Center font:12 isBold:YES text:@"邀请新节点:保存二维码至相册，分享二维码给好友，其他用户识别二维码并注册即可成为您的节点。" textColor:[UIColor whiteColor] superView:self.view];
    tipLabel.numberOfLines = 0;
    [tipLabel sizeToFit];
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
- (void)saveButtonClick {
    [self saveToPhoto:_qrCodeIamgeView.image];
}
- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
