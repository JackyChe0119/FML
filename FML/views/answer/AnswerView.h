//
//  AnswerView.h
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnswerItemView;
@interface AnswerView : UIView

@property (nonatomic, strong) UILabel* titleLB;

- (instancetype)initWithArray:(NSArray *)answerArray;

@property (nonatomic, strong) NSArray* answerArray;
@property (nonatomic, assign) NSInteger score;

@end

@interface AnswerItemView : UIView

@property (nonatomic, strong) UILabel*  leftLB;
@property (nonatomic, strong) UILabel*  rightLB;
@property (nonatomic, strong) UIButton* btn;
@property (nonatomic, assign) BOOL      isSelect;
@property (nonatomic, strong) UIImageView* checkIV;

@end
