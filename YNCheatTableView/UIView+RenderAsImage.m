//
//  UIView+RenderAsImage.m
//  sellerapp
//
//  Created by 杨智晓 on 15/11/27.
//  Copyright © 2015年 杨智晓. All rights reserved.
//

#import "UIView+RenderAsImage.h"

@implementation UIView (RenderAsImage)

+ (UIImage*)imageFromView:(UIView*)view

{
    
    //obtain scale
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
//    开始绘图，下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.frame.size.width,
                                                      view.frame.size.height),
                                           NO,
                                           scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
//    将view上的子view加进来
    [view.layer renderInContext:context];
//    CGContextRestoreGState(context);
    //开始生成图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
@end
