//
//  MJBaseViewController.m
//  KangDuKe
//
//  Created by 车杰 on 16/12/11.
//  Copyright © 2016年 Jacky. All rights reserved.
//

#import "MJBaseViewController.h"
#import "HUProgressView.h"
#import <CoreLocation/CoreLocation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD.h"
#import "UIView+Toast.h"

@interface MJBaseViewController ()

@end

@implementation MJBaseViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    // 获取系统自带滑动手势的target对象
//    self.navigationController.navigationBar.translucent = NO;
//     self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.barTintColor = colorWithHexString(@"#ffffff");
    self.navigationController.navigationBar.hidden = YES;
}
// 作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//    // 判断导航控制器是否只有一个子控制器，如果只有一个子控制器，肯定是根控制器
//    if (self.childViewControllers.count == 1) {
//        // 表示用户在根控制器界面，就不需要触发滑动手势，
//        return NO;
//    }
//    return YES;
//}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
-(BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (void)makeLineAtY:(float)Y view:(UIView *)view {
    CALayer * layer = [[CALayer alloc] init];
    [view.layer addSublayer:layer];
}
- (UIView *)customNavView {
    if (!_customNavView) {
        _customNavView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, NavHeight) color:[UIColor whiteColor]];
        [self.view addSubview:_customNavView];
    }
    return _customNavView;
}
//布局导航条左侧图片按钮
- (void)navgationLeftButtonImage:(NSString *)iocn {
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:iocn];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavView addSubview:_leftButton];
}
//布局导航条右侧图片按钮
- (void)navgationRightButtonImage:(NSString *)icon {
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *rightImage = [UIImage imageNamed:icon];
    _rightButton.frame = CGRectMake(ScreenWidth-44, StatusBarHeight, 44,44);
    [_rightButton setImage:rightImage forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(navgationRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavView addSubview:_rightButton];
}
/**
 *	@brief	设置标题颜色和大小
 */
- (void)NavigationItemTitle:(NSString *)title Color:(UIColor *)color {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new];
        [titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:19 isBold:YES text:title textColor:color superView:self.customNavView];
        _titleLabel = titleLabel;
    }
}
//布局导航条左侧标题按钮，颜色
- (void)navgationLeftButtonTitle:(NSString *)title color:(UIColor *)color {
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44,44);
    [_leftButton setTitle:title forState:UIControlStateNormal];
    _leftButton.titleLabel.font = FONT(15);
    [_leftButton setTitleColor:color forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavView addSubview:_leftButton];
}
//布局导航条右侧标题按钮，颜色
- (void)navgationRightButtonTitle:(NSString *)title color:(UIColor *)color {
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(ScreenWidth-54, StatusBarHeight, 44,44);
    [_rightButton setTitle:title forState:UIControlStateNormal];
    _rightButton.titleLabel.font = FONT(15);
    [_rightButton setTitleColor:color forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(navgationRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.customNavView addSubview:_rightButton];
}
//展示shadow//是否有颜色
- (void)showShadowViewWithColor:(BOOL)color {
    if (!_shadowView) {
        self.shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    if (color) {
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5];
    }else {
        self.shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    }
    
    self.shadowView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInshadowView:)];
    tap.delegate = self;
    [self.shadowView addGestureRecognizer:tap];
    [MainWindow addSubview:self.shadowView];
}
//隐藏蒙版
- (void)hiddenShadowView {
    [UIView animateWithDuration:.3 animations:^{
        self.shadowView.alpha = 0;
    } completion:^(BOOL finished) {
        [_shadowView removeFromSuperview];
        _shadowView= nil;
    }];
}
- (void)backUpButtonClick {
    [self clickOnRequestShadowView];
}
- (void)clickOnRequestShadowView {
    
}
- (void)tapInshadowView:(UIGestureRecognizer *)tap {
    NSLog(@"点击蒙版了");
    // 判断如果调用了代理 执行代理方法
    if ([_shadowViewDelegate respondsToSelector:@selector(touchesInShadowView)]) {
        [_shadowViewDelegate touchesInShadowView];
    }
}
//左侧按钮点击事件，子类重写实现自己的方法
- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

//右侧按钮点击事件，子类重写实现自己的方法
- (void)navgationRightButtonClick {NSLog(@"...");}
-(void)dealloc{
    //TODO
}
- (void)showToastHUD:(NSString *)message {
    [CommonToastHUD showTips:message];
//    [self.view makeToast:message duration:1 position:CSToastPositionCenter];
}
- (NSString *)getToken {
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return token;
}
- (NSString *)getInfoWithKey:(NSString *)key {
    NSString *value = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return value;
    
}
//获取表底部视图
- (UIImageView *)backGroundView:(NSString *)imageName superView:(UIView *)view{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:view.frame];
    imageview.image = [UIImage imageNamed:imageName];
    imageview.contentMode = UIViewContentModeCenter;
    imageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInBackGroundView:)];
    [imageview addGestureRecognizer:tap];
    return imageview;
}
- (void)tapInBackGroundView:(UITapGestureRecognizer *)tap {
    [self navgationRightButtonClick];
}
- (void)hideAlertAnimation:(UIView *)view  {
    [UIView beginAnimations:@"fadeIn" context:nil];
    [UIView animateWithDuration:0.35 animations:^{
        view.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}
- (void)showProgressHud {
    [MBProgressHUD showHUDAddedTo:MainWindow animated:YES];
}
- (void)showProgressHudWithTitle:(NSString *)title {
    [MBProgressHUD showHUDAddedTo:MainWindow animated:YES title:title];
}
- (void)hiddenProgressHud {
    [MBProgressHUD hideHUDForView:MainWindow animated:YES];
}
- (void)saveToPhoto:(UIImage *)image
{
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    NSMutableArray *groups=[[NSMutableArray alloc]init];
    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group)
        {
            [groups addObject:group];
        }
        
        else
        {
            BOOL haveHDRGroup = NO;
            
            for (ALAssetsGroup *gp in groups)
            {
                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
                
                if ([name isEqualToString:@"数钱钱"])
                {
                    haveHDRGroup = YES;
                }
            }
            
            if (!haveHDRGroup)
            {
                //do add a group named "XXXX"
                [assetsLibrary addAssetsGroupAlbumWithName:@"数钱钱"
                                               resultBlock:^(ALAssetsGroup *group)
                 {
                     if (!group) {
                     }else {
                         [groups addObject:group];
                         
                     }
                     
                 }
                                              failureBlock:nil];
                haveHDRGroup = YES;
            }
        }
        
    };
    //创建相簿
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
    
    [self saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(image) customAlbumName:@"数钱钱" completionBlock:^
     {
         //这里可以创建添加成功的方法
         dispatch_async(dispatch_get_main_queue(), ^{
             [self showToastHUD:@"保存成功"];
             
         });
         
     }
                     failureBlock:^(NSError *error)
     {
         //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
         dispatch_async(dispatch_get_main_queue(), ^{
             
             //添加失败一般是由用户不允许应用访问相册造成的，这边可以取出这种情况加以判断一下
             if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
                 UIAlertView *alert=[[UIAlertView alloc]initWithTitle:error.localizedDescription message:@"请在设置-应用列表里允许照片访问" delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", nil) otherButtonTitles: nil];
                 
                 [alert show];
             }
         });
     }];
}

- (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                customAlbumName:(NSString *)customAlbumName
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    __weak ALAssetsLibrary *weakSelf = assetsLibrary;
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                if (customAlbumName) {
                    if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:customAlbumName]) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    }
                }else {
                    if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"相机胶卷"]) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    }
                }
                
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (customAlbumName) {
            [assetsLibrary addAssetsGroupAlbumWithName:customAlbumName resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [weakSelf assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(weakSelf, assetURL);
                    if (completionBlock) {
                        completionBlock();
                    }
                    
                }
            } failureBlock:^(NSError *error) {
                AddAsset(weakSelf, assetURL);
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } else {
            if (completionBlock) {
                completionBlock();
            }
            
        }
    }];
}
//跳转页面并隐藏tabbar
- (void)pushViewControllerHidesBottomBar:(UIViewController *)vc{
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//隐藏导航栏底部黑线
- (void)hideNavBarLineView{
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
}
- (BOOL)checkPrice:(NSString *)price {
    

    
    NSString *pattern = @"^([1-9]\\d*|0)(\\.\\d?[0-9])?$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    BOOL isMatch = [pred evaluateWithObject:price];
    
    return isMatch;
    
}
- (BOOL)isTrueValue:(NSString *)vaule {

    if ([vaule containsString:@"."]) {
        NSString *last = [[vaule componentsSeparatedByString:@"."] lastObject];
        if (last.length>=2) {
            return NO;
        }
    }
    return YES;
}
- (void)layoutNavViewWith:(NSInteger)type {
    
}
@end
