//
//  AnswerTopView.h
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnswerItem;
@interface AnswerTopView : UIView

- (void)next;
- (void)back;

@end

@interface AnswerItem : UIView

@property (nonatomic, strong) UIButton* btn;
@property (nonatomic, copy) NSString* title;
@property (nonatomic, assign) BOOL  isSelect;

@end
