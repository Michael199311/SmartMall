//
//  UIView+CRAdditions.h
//  CarRental
//
//  Created by 王健功 on 15/7/2.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CRAdditions)

/**
 *  从xib加载当前view
 *
 */
+ loadNibName:(NSString *)nibName;
/**
 *  制作圆角
 *
 */
- (void)makeCornerRadiusOfRadius:(CGFloat)radius;
- (void)makeCornerRadiusOfRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor;
/**
 *  获取当前view所在的uiviewController
 */
- (UIViewController*)viewController;

@end
