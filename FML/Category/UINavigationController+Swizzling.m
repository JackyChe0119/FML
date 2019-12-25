//
//  UINavigationController+Swizzling.m
//  FML
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UINavigationController+Swizzling.h"

@implementation UINavigationController (Swizzling)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod(self, @selector(fml_popToRootViewControllerAnimated:), @selector(popToRootViewControllerAnimated:));
        swizzling_exchangeMethod(self, @selector(fml_popViewControllerAnimated:), @selector(popViewControllerAnimated:));
        swizzling_exchangeMethod(self, @selector(fml_pushViewController:animated:), @selector(pushViewController:animated:));
    });
}

- (void)fml_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count != 0) {
        self.viewControllers[0].hidesBottomBarWhenPushed = YES;
    }
    [self fml_pushViewController:viewController animated:YES];
}

- (UIViewController *)fml_popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count == 2) {
        self.viewControllers[0].hidesBottomBarWhenPushed = NO;
    }
    return [self fml_popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)fml_popToRootViewControllerAnimated:(BOOL)animated {
    self.viewControllers[0].hidesBottomBarWhenPushed = NO;
    return [self fml_popToRootViewControllerAnimated:animated];
}

@end
