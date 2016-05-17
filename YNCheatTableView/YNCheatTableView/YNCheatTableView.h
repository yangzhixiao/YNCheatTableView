//
//  YNCheatTableView.h
//  YNTableViewCheatDemo
//
//  Created by 杨智晓 on 16/1/20.
//  Copyright © 2016年 杨智晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YNCheatTableViewDelegate;

@interface YNCheatTableView : UITableView

@property (assign, nonatomic) id<YNCheatTableViewDelegate> cheatDelegate;
@property (assign, nonatomic) BOOL debug;
@property (assign, nonatomic) CGFloat shouldScrollDistance;
@property (assign, nonatomic) NSTimeInterval scrollAnimateDuration;

- (void)setupCheatView;

@end

@protocol YNCheatTableViewDelegate <NSObject>
- (NSInteger)columnCountForCheat;
- (CGFloat)YNCheatTableViewShouldCaptureViewAtPositonY;

@optional
- (BOOL)YNCheatTableView:(YNCheatTableView*)tableView ShouldScrollAtPoint:(CGPoint)panTouchPoint;
- (void)YNCheatTableView:(YNCheatTableView*)tableView didScrollTo:(NSInteger)index;
- (UIView*)loadingViewForTableViewAtIndex:(NSInteger)index;

@end

@interface YNScreenShotModel : NSObject
@property (copy, nonatomic) UIImage *image;
@property (assign, nonatomic) CGFloat lastOffsetY;
@property (assign, nonatomic) CGFloat lastPositionY;
@end
