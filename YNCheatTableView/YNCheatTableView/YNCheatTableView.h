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
@property (strong, nonatomic) UIColor *coverBgColor;

- (void)setupCheatView;
- (void)scrollToColumnAtIndex:(NSInteger)index;

@end

@protocol YNCheatTableViewDelegate <NSObject>
- (NSInteger)columnCountForCheat;
- (CGFloat)YNCheatTableViewShouldCaptureViewAtPositonY;

@optional
- (BOOL)YNCheatTableViewShouldScrollAtPoint:(CGPoint)panTouchPoint;
- (void)YNCheatTableViewDidScrollTo:(NSInteger)index;
- (UIView*)loadingViewForTableViewAtIndex:(NSInteger)index;

@end

@interface YNScreenShotModel : NSObject
@property (copy, nonatomic) UIImage *image;
@property (assign, nonatomic) CGFloat lastOffsetY;
@property (assign, nonatomic) CGFloat lastPositionY;
@end
