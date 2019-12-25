//
//  LeftLableTextField.h
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQPreviousNextView.h>

@interface LeftLableTextField : IQPreviousNextView

@property (nonatomic, strong) UILabel* titleLB;
@property (nonatomic, strong) UITextField* textField;
@property (nonatomic, strong) UIView* bottomLine;
@property (nonatomic, assign) BOOL changeFrame;
@end
