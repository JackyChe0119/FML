//
//  ChangeIconViewController.m
//  FML
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ChangeIconViewController.h"
#import "FMLTransitionDelegate.h"

@interface ChangeIconViewController ()

@end

@implementation ChangeIconViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = ColorWhite;
    [self setView];


}

- (void)setView {
    
    UIButton* photograph = [UIButton buttonWithType:UIButtonTypeCustom];
    [photograph setTitle:@"拍照" forState:UIControlStateNormal];
    [photograph setTitleColor:Color1D forState:UIControlStateNormal];
    [photograph addTarget:self action:@selector(photograph) forControlEvents:UIControlEventTouchUpInside];
    photograph.titleLabel.font = [UIFont systemFontOfSize:16];
    photograph.frame = CGRectMake(0, 0, ScreenWidth, 55);
    [self.view addSubview:photograph];
    
    UIButton* selectPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectPhoto setTitle:@"从手机相册选择" forState:UIControlStateNormal];
    [selectPhoto setTitleColor:Color1D forState:UIControlStateNormal];
    [selectPhoto addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
    selectPhoto.frame = CGRectMake(0, photograph.bottom, ScreenWidth, 55);
    selectPhoto.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:selectPhoto];
    
    UIView* line = [UIView new];
    line.backgroundColor = ColorLine;
    line.frame = CGRectMake(0, selectPhoto.bottom, ScreenWidth, 0.5);
    [self.view addSubview:line];
    
    UIButton* cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:Color1D forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    cancel.frame = CGRectMake(0, line.bottom, ScreenWidth, 55);
    cancel.titleLabel.font = [UIFont systemFontOfSize:16];

    [self.view addSubview:cancel];

}

- (void)photograph {

    [self dismissViewControllerAnimated:YES completion:nil];
    if (_selectPhotoType) {
        _selectPhotoType(0);
    }
}

- (void)selectPhoto {

    [self dismissViewControllerAnimated:YES completion:nil];
    if (_selectPhotoType) {
        _selectPhotoType(1);
    }
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
