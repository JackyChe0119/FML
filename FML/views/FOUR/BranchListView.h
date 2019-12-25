//
//  BranchListView.h
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BranchListView : UIImageView

@property (nonatomic, copy) void (^ reloadDataCompletion)(BranchListView* listView ,NSInteger num);
@property (nonatomic, assign) BOOL  isScoll;
@property (nonatomic, assign) BOOL  isTeam;

- (void)getTeamList:(int)pageNum;

@end
