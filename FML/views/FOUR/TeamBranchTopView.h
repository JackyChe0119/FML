//
//  TeamBranchTopView.h
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamBranchTopView : UIImageView

@property (nonatomic, strong) NSString* num;
@property (nonatomic, strong) NSString* teamId;
@property (nonatomic, copy)NSString *shouyi;
@property (nonatomic,copy)NSString *email;
- (instancetype)initWithFrame:(CGRect)frame type:(NSInteger)state;
@end
