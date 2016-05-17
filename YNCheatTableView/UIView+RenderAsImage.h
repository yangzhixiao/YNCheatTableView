//
//  UIView+RenderAsImage.h
//  sellerapp
//
//  Created by 杨智晓 on 15/11/27.
//  Copyright © 2015年 杨智晓. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RenderAsImage)
+ (UIImage*)imageFromView:(UIView*)view;
- (UIImage*)image;
@end
