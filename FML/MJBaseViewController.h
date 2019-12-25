//
//  MJBaseViewController.h
//  KangDuKe
//
//  Created by 车杰 on 16/12/11.
//  Copyright © 2016年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomBaseViewController.h"

// ****** 申明代理 ****** /
@protocol ShadowViewDelegate <NSObject>

// ****** 可选方法 ****** /
@optional

// ****** 点击蒙版 触发代理事件 ****** /
- (void)touchesInShadowView;

@end
@interface MJBaseViewController : CustomBaseViewController <UIGestureRecognizerDelegate,UINavigationBarDelegate>
@property (nonatomic,strong)UIView *shadowView;
@property (nonatomic,strong)UIView *progressBaseView;
@property (nonatomic,assign) BOOL showRefresh;
@property (nonatomic,strong) UIView *customNavView;
@property (nonatomic,strong)UIButton *rightButton,*leftButton;
@property (nonatomic, strong) UILabel* titleLabel;
@property (assign, nonatomic)id <ShadowViewDelegate>shadowViewDelegate; // ****** 设置代理属性 ****** /
//布局导航视图
- (void)layoutNavViewWith:(NSInteger)type;
- (BOOL)shouldAutorotate;
- (void)makeLineAtY:(float)Y view:(UIView *)view;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations;
- (void)clickOnRequestShadowView;
//布局导航条左侧图片按钮
- (void)navgationLeftButtonImage:(NSString *)icon;
//布局导航条右侧图片按钮
- (void)navgationRightButtonImage:(NSString *)icon;
//标题和标题颜色
- (void)NavigationItemTitle:(NSString *)title Color:(UIColor *)color;
//布局导航条左侧标题按钮，颜色
- (void)navgationLeftButtonTitle:(NSString *)title color:(UIColor *)color;
//布局导航条右侧标题按钮，颜色
- (void)navgationRightButtonTitle:(NSString *)title color:(UIColor *)color;
//导航条右侧按钮点击
- (void)navgationRightButtonClick;
//导航条左侧按钮点击
- (void)navgationLeftButtonClick;
//展示shadow//是否有颜色
- (void)showShadowViewWithColor:(BOOL)color;
//隐藏蒙版
- (void)hiddenShadowView;
//提示信息
- (void)showToastHUD:(NSString *)message;
- (NSString *)getToken;
- (NSString *)getInfoWithKey:(NSString *)key;
- (UIImageView *)backGroundView:(NSString *)imageName superView:(UIView *)view;
//视图渐变消失
- (void)hideAlertAnimation:(UIView *)view;
- (void)showProgressHud;
//带标题的提示框
- (void)showProgressHudWithTitle:(NSString *)title;
- (void)hiddenProgressHud;
//保存图片之本地
- (void)saveToPhoto:(UIImage *)image;
//跳转页面并隐藏tabbar
- (void)pushViewControllerHidesBottomBar:(UIViewController *)vc;
//隐藏导航栏底部黑线
- (void)hideNavBarLineView;
- (BOOL)checkPrice:(NSString *)price;
- (BOOL)isTrueValue:(NSString *)vaule;
@end
