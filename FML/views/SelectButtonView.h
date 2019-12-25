//
//  SelectButtonView.h
//  KangDuKe
//
//  Created by 车杰 on 17/2/23.
//  Copyright © 2017年 MJ Science and Technology Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectButtonView;
@protocol selectButtonDelegate<NSObject>
@optional
- (void)DelegateDidClickAtAnyImageView:(SelectButtonView *)selectButton;
@end
typedef void (^selectButtonBlock) (NSInteger tag);
@interface SelectButtonView : UIView
@property (nonatomic,strong)UIButton *selectButton;
@property (nonatomic,strong) UIImage *imageStr;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *titleColor;
@property (nonatomic,assign) NSInteger font;
@property (nonatomic,strong) selectButtonBlock block;
@property (nonatomic,assign)id <selectButtonDelegate> delegate;
@end
