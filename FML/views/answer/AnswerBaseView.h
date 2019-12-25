//
//  AnswerBaseView.h
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftLableTextField.h"

@interface AnswerBaseView : UIView

@property (nonatomic, strong) UIButton* btn;

@property (nonatomic, copy) void (^baseAnswerHandler)();
-(void)closeW;

@end
