//
//  ScreenShotModel.h
//  userapp
//
//  Created by 杨智晓 on 16/1/21.
//  Copyright © 2016年 杨智晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenShotModel : NSObject
@property (copy, nonatomic) UIImage *image;
@property (assign, nonatomic) CGFloat lastOffsetY;
@property (assign, nonatomic) CGFloat lastPositionY;
@end
