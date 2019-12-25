//
//  MainViewController.m
//  ManggeekBaseProject
//
//  Created by 车杰 on 2017/9/25.
//  Copyright © 2017年 Jacky. All rights reserved.
//

#import "MainViewController.h"
#import "baseFourViewController.h"
#import "baseOneViewController.h"
#import "baseThreeViewController.h"
#import "baseTwoViewController.h"
#import "baseThreeViewControllernew.h"
#import "InterstellarViewController.h"
#import "TeamBranchViewController.h"
@interface MainViewController ()<UITabBarControllerDelegate>
{
    NSInteger _currentIndex;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        baseOneViewController *oneVC = [[baseOneViewController alloc]init];
        UINavigationController *oneNav = [[UINavigationController alloc]initWithRootViewController:oneVC];
        oneNav.tabBarItem.image=[UIImage imageNamed:@"icon_base2"];
        oneNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_base1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        oneNav.tabBarItem.title=@"资产";
        [oneNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorBlue,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        baseTwoViewController *twoVc = [[baseTwoViewController alloc]init];
        UINavigationController *twoNav = [[UINavigationController alloc]initWithRootViewController:twoVc];
        twoNav.tabBarItem.image=[UIImage imageNamed:@"icon_base3"];
        twoNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_base4"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        twoNav.tabBarItem.title=@"投资";
        [twoNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorBlue,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        baseThreeViewControllernew *threeVc = [[baseThreeViewControllernew alloc]init];
        UINavigationController *MthreeNav = [[UINavigationController alloc]initWithRootViewController:threeVc];
        MthreeNav.tabBarItem.image=[UIImage imageNamed:@"icon_base5"];
        MthreeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_base6"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        MthreeNav.tabBarItem.title=@"C2C";
        [MthreeNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorBlue,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
//        TeamBranchViewController *fourVc = [[TeamBranchViewController alloc]init];
        InterstellarViewController *fourVc = [[InterstellarViewController alloc]init];
        UINavigationController *fourNav = [[UINavigationController alloc]initWithRootViewController:fourVc];
        fourNav.tabBarItem.image=[UIImage imageNamed:@"icon_center"];
        fourNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_center_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [fourNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorBlue,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        fourNav.tabBarItem.title=@"星际节点";
        
        baseFourViewController *fiveVc = [[baseFourViewController alloc]init];
        UINavigationController *fiveNav = [[UINavigationController alloc]initWithRootViewController:fiveVc];
        fiveNav.tabBarItem.image=[UIImage imageNamed:@"icon_base7"];
        fiveNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_base8"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [fiveNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:ColorBlue,NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        fiveNav.tabBarItem.title=@"我的";
        
        
        self.viewControllers = @[oneNav, twoNav, fourNav,MthreeNav, fiveNav];
        
        self.selectedIndex = 0;
        self.delegate = self;
        
    }
    return self;
}
#pragma mark - UITabBarController代理方法 点击事件
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    //点击tabBarItem动画
    if (self.selectedIndex != _currentIndex)[self tabBarButtonClick:[self getTabBarButton]];
}
-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}
- (UIControl *)getTabBarButton{
    
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (UIView *tabBarButton in self.tabBar.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtons addObject:tabBarButton];
        }
    }
    
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];
            
        }
    }
    _currentIndex = self.selectedIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
