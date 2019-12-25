//
//  AnswerScrollView.h
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerView.h"

@interface AnswerScrollView : UIView

@property (nonatomic, copy) NSArray*  titles;
@property (nonatomic, copy) NSArray<NSArray *>*  answerArray;
@property (nonatomic, assign) BOOL    isHaveNext;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) UIButton *btn;

- (void)showView;

@property (nonatomic, copy) void (^finishHandler)();
@property (nonatomic, copy) void (^nextHandler)();
@property (nonatomic, copy) void (^backHandler)();

@end
