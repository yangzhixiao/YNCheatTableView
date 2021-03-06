//
//  ZXCheatTableView.m
//  ZXTableViewCheatDemo
//
//  Created by 杨智晓 on 16/1/20.
//  Copyright © 2016年 杨智晓. All rights reserved.
//

#import "YNCheatTableView.h"

//#define YNLog(...) NSLog(__VA_ARGS__)
#define YNLog(...)

#define kContent_Width [UIScreen mainScreen].bounds.size.width

@interface YNCheatTableView()<UIGestureRecognizerDelegate>
@property (assign, nonatomic) NSInteger columnCount;
@property (strong, nonatomic) UIImageView *leftView;
@property (strong, nonatomic) UIImageView *rightView;
@property (strong, nonatomic) UIImageView *centerView;
@property (strong, nonatomic) UIView *coverBgView;
@property (assign, nonatomic) CGPoint lastPanPoint;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) UIPanGestureRecognizer *panGest;
@property (strong, nonatomic) NSMutableDictionary *screenshotDict;
@property (assign, nonatomic) CGFloat currentCaptureOffsetY;
@property (assign, nonatomic) BOOL hasCoverViews;
@end

@implementation YNCheatTableView

#pragma mark - Public Methods

- (void)setupCheatView
{
    if (self.shouldScrollDistance == 0) {
        self.shouldScrollDistance = 40;
    }
    
    if (self.scrollAnimateDuration == 0) {
        self.scrollAnimateDuration = 0.23f;
    }
    
    if (!self.coverBgColor) {
        self.coverBgColor = [UIColor whiteColor];
    }
    
    self.currentIndex = 0;
    self.screenshotDict = [NSMutableDictionary dictionary];
    self.hasCoverViews = NO;
    
    self.columnCount = [self.cheatDelegate columnCountForCheat];
    
    [self.superview removeGestureRecognizer:self.panGest];
    [self.panGest removeTarget:self action:@selector(handle:)];
    self.panGest.delegate = nil;
    
    self.panGest = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handle:)];
    [self.superview addGestureRecognizer:self.panGest];
    self.panGest.delegate = self;
    
}

- (void)scrollToColumnAtIndex:(NSInteger)index {
    
    if (self.currentIndex > index) { // Left
        [self buildCoverViews];
        self.currentIndex = index;
        [self animateRight: YES];
        YNLog(@"Left: %@", @(index));
    }
    
    if (self.currentIndex < index) { // Right
        [self buildCoverViews];
        self.currentIndex = index;
        [self animateLeft: YES];
        YNLog(@"Right: %@", @(index));
    }
    
}

#pragma mark - Private Methods

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGest
        && self.cheatDelegate
        && [self.cheatDelegate respondsToSelector:@selector(YNCheatTableViewShouldScrollAtPoint:)]) {
        CGPoint curPoint = [gestureRecognizer locationInView:self.superview];
        return [self.cheatDelegate YNCheatTableViewShouldScrollAtPoint:curPoint];
    }
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

- (void)handle:(UIPanGestureRecognizer *)panGest {
    
    CGPoint curPoint = [panGest locationInView:self.superview];
    if (!self.hasCoverViews
        && [self.cheatDelegate respondsToSelector:@selector(YNCheatTableViewShouldScrollAtPoint:)]
        && ![self.cheatDelegate YNCheatTableViewShouldScrollAtPoint:curPoint]) {
        return;
    }
    
    if (panGest.state == UIGestureRecognizerStateBegan) {
        
    }
    
    if (panGest.state == UIGestureRecognizerStateChanged) {
        YNLog(@"UIGestureRecognizerStateChanged");
        CGFloat offsetX = curPoint.x - self.lastPanPoint.x;
        
        if (offsetX > 0
            && self.currentIndex == 0
            && self.centerView.frame.origin.x >= 0) { //右
            //            [self removeCoverViews];
            return;
        } else if (offsetX < 0
                   && self.currentIndex == self.columnCount - 1
                   && self.centerView.frame.origin.x <= 0) { //左
            //            [self removeCoverViews];
            return;
        }
        
        if (!self.hasCoverViews) {
            [self buildCoverViews];
        }
        
        CGRect frame = self.centerView.frame;
        frame.origin.x += offsetX;
        self.centerView.frame = frame;
        
        frame = self.leftView.frame;
        frame.origin.x += offsetX;
        self.leftView.frame = frame;
        
        frame = self.rightView.frame;
        frame.origin.x += offsetX;
        self.rightView.frame = frame;
        
    }
    
    if (panGest.state == UIGestureRecognizerStateEnded) {
        YNLog(@"UIGestureRecognizerStateEnded");
        if (self.debug) {
            return;
        }
        
        if (self.centerView.frame.origin.x == 0) {
            [self removeCoverViews];
            return;
        }
        self.panGest.enabled = NO;
        
        CGFloat scrollOffsetX = self.shouldScrollDistance;
        NSTimeInterval scrollInterval = self.scrollAnimateDuration;
        
        __weak YNCheatTableView *ws = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((scrollInterval + 0.05) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ws.panGest.enabled = YES;
        });
        
        if (self.centerView.frame.origin.x <= -scrollOffsetX ) { //左
            
            if (self.currentIndex == self.columnCount - 1) {
                [self resetPosition:YES];
                YNLog(@"-should animate reset position");
                return;
            }
            
            YNLog(@"-should animate left");
            self.currentIndex ++;
            [self animateLeft];
            
        } else if(self.centerView.frame.origin.x < 0) {
            CGRect rightFrame = self.rightView.frame;
            rightFrame.origin.x = self.centerView.frame.size.width;
            
            CGRect centerFrame = self.centerView.frame;
            centerFrame.origin.x = 0;
            [UIView animateWithDuration:scrollInterval animations:^{
                ws.rightView.frame = rightFrame;
                ws.centerView.frame = centerFrame;
            } completion:^(BOOL finished) {
                [ws removeCoverViews];
            }];
        }
        
        
        if (self.centerView.frame.origin.x >= scrollOffsetX) {  //右
            
            if (self.currentIndex == 0) {
                [self resetPosition:YES];
                YNLog(@"-should animate reset position");
                return;
            }
            
            YNLog(@"-should animate right");
            self.currentIndex --;
            [self animateRight];
            
        } else if (self.centerView.frame.origin.x > 0 && self.centerView.frame.origin.x < scrollOffsetX) {
            CGRect leftFrame = self.leftView.frame;
            leftFrame.origin.x = - self.leftView.frame.size.width;
            
            CGRect centerFrame = self.centerView.frame;
            centerFrame.origin.x = 0;
            [UIView animateWithDuration:scrollInterval animations:^{
                ws.leftView.frame = leftFrame;
                ws.centerView.frame = centerFrame;
            } completion:^(BOOL finished) {
                [ws removeCoverViews];
            }];
        }
        
    }
    
    self.lastPanPoint = curPoint;
}

- (void)removeCoverViews {
    YNScreenShotModel *model = [self.screenshotDict objectForKey:@(self.currentIndex)];
    if (model && model.lastOffsetY == self.currentCaptureOffsetY) {
        CGRect bounds = self.bounds;
        bounds.origin.y = model.lastPositionY;
        self.bounds = bounds;
    }
    
    if (self.leftView) {
        [self.leftView removeFromSuperview];
        YNLog(@"-remove left view: %p", self.leftView);
    }
    
    if (self.rightView) {
        [self.rightView removeFromSuperview];
        YNLog(@"-remove right view: %p", self.rightView);
    }
    
    if (self.centerView) {
        [self.centerView removeFromSuperview];
        YNLog(@"-remove center view: %p", self.centerView);
    }
    
    if (self.coverBgView) {
        [self.coverBgView removeFromSuperview];
        YNLog(@"-remove bgView view: %p", self.coverBgView);
    }
    
    self.leftView = nil;
    self.rightView = nil;
    self.centerView = nil;
    self.coverBgView = nil;
    
    self.hasCoverViews = NO;
}

- (UIImageView *)CaptureViewAtIndex:(NSInteger)index offsetY:(CGFloat)offsetY {
    
    UIImageView *coverView = [[UIImageView alloc]init];
    coverView.contentMode = UIViewContentModeBottom;
    coverView.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = nil;
    
    if (index < 0 || index >= self.columnCount) {
        return coverView;
    }
    
    if (index == self.currentIndex) {
        
        UIImage *image = [self imageForView:self.superview];
        YNLog(@"image size: %@", NSStringFromCGSize(image.size));
        YNLog(@"screen size: %@", NSStringFromCGSize([UIScreen mainScreen].bounds.size));
        imageView = [[UIImageView alloc]initWithImage:image];
        
        YNScreenShotModel *model = [YNScreenShotModel new];
        model.image = image;
        model.lastOffsetY = offsetY;
        model.lastPositionY = self.bounds.origin.y;
        [self.screenshotDict setObject:model forKey:@(index)];
        
    } else {
        
        if ([self.screenshotDict objectForKey:@(index)]) {
            YNScreenShotModel *model = [self.screenshotDict objectForKey:@(index)];
            imageView = [[UIImageView alloc]initWithImage:model.image];
            YNLog(@"lastOffsetY: %@, posY: %@, offset: %@", @(model.lastOffsetY), @(offsetY), @(model.lastOffsetY-offsetY));
            if (model.lastOffsetY - offsetY > 0) {
                UIView *blankView = [[UIView alloc]init];
                blankView.frame = CGRectMake(0, offsetY, kContent_Width, model.lastOffsetY-offsetY);
                blankView.backgroundColor = [UIColor whiteColor];
                [coverView addSubview:blankView];
                YNLog(@"blank: %@", NSStringFromCGRect(blankView.frame));
            } else if (offsetY - model.lastOffsetY > 0) {
                
            }
        } else {
            imageView = [[UIImageView alloc]init];
            imageView.backgroundColor = [UIColor whiteColor];
            
            if (self.cheatDelegate
                && [self.cheatDelegate respondsToSelector:@selector(loadingViewForTableViewAtIndex:)]) {
                
                UIView *loadingView = [self.cheatDelegate loadingViewForTableViewAtIndex:self.currentIndex];
                loadingView.center = CGPointMake(self.bounds.size.width / 2.f, 30);
                [imageView addSubview:loadingView];
                
            } else {
                UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                activityView.center = CGPointMake(self.bounds.size.width / 2.f, 30);
                [imageView addSubview:activityView];
                [activityView startAnimating];
            }
            
        }
    }
    
    imageView.frame = CGRectMake(0,
                                 offsetY,
                                 self.superview.bounds.size.width,
                                 self.superview.bounds.size.height-offsetY);
    YNLog(@"index: %@, imageView: %@", @(index), NSStringFromCGRect(imageView.frame));
    imageView.contentMode = UIViewContentModeBottom;
    imageView.layer.masksToBounds = YES;
    [coverView addSubview:imageView];
    [coverView sendSubviewToBack:imageView];
    
    return coverView;
}

- (void)buildCoverViews {
    UIView *parentView = self.superview;
    
    //left
    CGRect frame = CGRectMake(-parentView.bounds.size.width,
                              0,
                              parentView.bounds.size.width,
                              parentView.bounds.size.height);
    CGFloat captureOffsetY = [self.cheatDelegate YNCheatTableViewShouldCaptureViewAtPositonY];
    self.currentCaptureOffsetY = captureOffsetY;
    UIImageView *leftView = [self CaptureViewAtIndex:self.currentIndex-1 offsetY:captureOffsetY];
    leftView.frame = frame;
    [parentView addSubview:leftView];
    self.leftView = leftView;
    YNLog(@"-build left: %p", leftView);
    
    //center
    UIImageView *centerView = [self CaptureViewAtIndex:self.currentIndex offsetY:captureOffsetY];
    centerView.frame = CGRectMake(0,
                                  0,
                                  parentView.bounds.size.width,
                                  parentView.bounds.size.height);
    [parentView addSubview: centerView];
    self.centerView = centerView;
    YNLog(@"-build center: %p", centerView);
    
    //right
    frame = CGRectMake(parentView.bounds.size.width,
                       0,
                       parentView.bounds.size.width,
                       parentView.bounds.size.height);
    UIImageView *rightView = [self CaptureViewAtIndex:self.currentIndex+1 offsetY:captureOffsetY];
    rightView.frame = frame;
    [parentView addSubview:rightView];
    self.rightView = rightView;
    YNLog(@"-build rightView: %p", rightView);
    
    // bg views
    CGRect bgFrame = CGRectMake(0,
                                captureOffsetY,
                                parentView.bounds.size.width,
                                parentView.bounds.size.height-captureOffsetY);
    UIView *bgView = [[UIView alloc]init];
    bgView.frame = bgFrame;
    bgView.backgroundColor = self.coverBgColor;
    [parentView insertSubview:bgView aboveSubview:self];
    self.coverBgView = bgView;
    YNLog(@"-build bgView: %p", bgView);
    
    self.hasCoverViews = YES;
}

- (void)animateLeft {
    [self animateLeft:NO];
}

- (void)animateLeft:(BOOL)justAnimate {
    CGRect rightFrame = self.rightView.frame;
    rightFrame.origin.x = 0;
    
    CGRect centerFrame = self.centerView.frame;
    centerFrame.origin.x = - self.centerView.frame.size.width;
    
    __weak YNCheatTableView *ws = self;
    [UIView animateWithDuration:self.scrollAnimateDuration animations:^{
        ws.rightView.frame = rightFrame;
        ws.centerView.frame = centerFrame;
    } completion:^(BOOL finished) {
        if (!justAnimate
            && ws.cheatDelegate
            && [ws.cheatDelegate respondsToSelector:@selector(YNCheatTableViewDidScrollTo:)]) {
            [ws.cheatDelegate YNCheatTableViewDidScrollTo:ws.currentIndex];
        }
        [ws removeCoverViews];
    }];
}


- (void)animateRight {
    [self animateRight: NO];
}

- (void)animateRight:(BOOL)justAnimate {
    CGRect leftFrame = self.leftView.frame;
    leftFrame.origin.x = 0;
    
    CGRect centerFrame = self.centerView.frame;
    centerFrame.origin.x = self.centerView.frame.size.width;
    
    __weak YNCheatTableView *ws = self;
    [UIView animateWithDuration:self.scrollAnimateDuration animations:^{
        ws.leftView.frame = leftFrame;
        ws.centerView.frame = centerFrame;
    } completion:^(BOOL finished) {
        if (!justAnimate
            && ws.cheatDelegate
            && [ws.cheatDelegate respondsToSelector:@selector(YNCheatTableViewDidScrollTo:)]) {
            [ws.cheatDelegate YNCheatTableViewDidScrollTo:ws.currentIndex];
        }
        [ws removeCoverViews];
    }];
}

- (void)resetPosition {
    [self resetPosition:NO];
}

- (void)resetPosition:(BOOL)justAnimate {
    UIView *parentView = self.superview;
    
    CGRect leftFrame = self.leftView.frame;
    leftFrame.origin.x = -parentView.bounds.size.width;
    
    CGRect rightFrame = self.rightView.frame;
    rightFrame.origin.x = parentView.bounds.size.width;
    
    CGRect centerFrame = self.centerView.frame;
    centerFrame.origin.x = 0;
    
    __weak YNCheatTableView *ws = self;
    [UIView animateWithDuration:self.scrollAnimateDuration animations:^{
        ws.leftView.frame = leftFrame;
        ws.rightView.frame = rightFrame;
        ws.centerView.frame = centerFrame;
    } completion:^(BOOL finished) {
        if (!justAnimate
            && ws.cheatDelegate
            && [ws.cheatDelegate respondsToSelector:@selector(YNCheatTableViewDidScrollTo:)]) {
            [ws.cheatDelegate YNCheatTableViewDidScrollTo:ws.currentIndex];
        }
        [ws removeCoverViews];
    }];
}

- (UIImage *)imageForView: (UIView*)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setDebug:(BOOL)debug {
    _debug = debug;
    if (!debug) {
        [self removeCoverViews];
    }
}

@end


@implementation YNScreenShotModel

@end
