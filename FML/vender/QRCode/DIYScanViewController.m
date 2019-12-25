//
//  DIYScanViewController.m
//  LBXScanDemo
//
//  Created by lbxia on 2017/6/5.
//  Copyright © 2017年 lbx. All rights reserved.
//

#import "DIYScanViewController.h"
#import "SelectPhotoManager.h"
#import "ZXingObjC.h"
#import "CommonToastHUD.h"
#import "MBProgressHUD.h"

@interface DIYScanViewController ()

@property (nonatomic, strong) UIView* fixbugView;
@property (nonatomic, strong) SelectPhotoManager* photoManager;

@end

@implementation DIYScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//
    self.cameraInvokeMsg = @"相机启动中";
    
    self.qRScanView.height = ScreenHeight + TabBarHeight;
    self.view.backgroundColor = ColorBg;
    self.qRScanView.backgroundColor = ColorBg;

}

- (void)topView {
    
    UIView* customNavView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, NavHeight) color:[ColorWhite colorWithAlphaComponent:0.5]];
    [self.view addSubview:customNavView];
    
    UIButton* _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:backUp];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [customNavView addSubview:_leftButton];
    
    UIButton* _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(ScreenWidth-54, StatusBarHeight, 44,44);
    [_rightButton setTitle:@"相册" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = FONT(15);
    [_rightButton setTitleColor:Color1D forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(navgationRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [customNavView addSubview:_rightButton];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:19 isBold:YES text:@"加入团队" textColor:Color1D superView:customNavView];
}

- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navgationRightButtonClick {
    if (!_photoManager) {
        _photoManager =[[SelectPhotoManager alloc]init];
    }
    _photoManager.superVC = self;
    [_photoManager selectPhotoWithType:1];
    __weak typeof(self) weakSelf = self;
    //选取照片成功
    _photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
        [weakSelf resultQRCode:image];
    };
    
    _photoManager.errorHandle = ^(NSString *error) {
        
    };
}

- (void)resultQRCode:(UIImage *)image {
    CGImageRef imageRef = image.CGImage;
    ZXCGImageLuminanceSource * source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageRef];
    ZXBinaryBitmap * bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    NSError * error = nil;
    ZXDecodeHints * hints = [ZXDecodeHints hints];
    ZXMultiFormatReader * reader = [ZXMultiFormatReader reader];
    ZXResult * result = [reader decode:bitmap hints:hints error:&error];
    if (result) {
//        NSString * contents = result.text;
    } else {
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_fixbugView) {
        _fixbugView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 300)];
        _fixbugView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self.view addSubview:_fixbugView];
        [self topView];
    }
    
}
#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以ZXing同时识别2个二维码，不能同时识别二维码和条形码
    //    for (LBXScanResult *result in array) {
    //
    //        NSLog(@"scanResult:%@",result.strScanned);
    //    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //TODO: 这里可以根据需要自行添加震动或播放声音提示相关代码
    //...
    
    [self showNextVCWithScanResult:scanResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    NSLog(@"%@", strResult);
}

- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    [MBProgressHUD showHUDAddedTo:MainWindow animated:YES];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"itemId"] = strResult.strScanned;
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"item/add_item.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [MBProgressHUD hideHUDForView:MainWindow animated:YES];
        
        if (responseMessage.errorMessage) {
            [CommonToastHUD showTips:responseMessage.errorMessage];
        } else {
            [CommonToastHUD showTips:@"加入团队成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

@end


