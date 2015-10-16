//
//  UINavigationController+CRCustomNavigationController.h
//  CarRental
//
//  Created by 王健功 on 15/7/1.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (CRCustomNavigationController)

/**
 *  设置导航栏背景图片
 *
 */
+ (void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage;
/**
 *  设置导航栏的背景色
 *
 *  @param color 背景色
 */
+ (void)setNavigationBarBackgroundColor:(UIColor *)backgroundColor;

/**
 *  设置导航栏标题属性
 *  UITextAttributeFont – 字体key
 *  UITextAttributeTextColor – 文字颜色key
 *  UITextAttributeTextShadowColor – 文字阴影色key
 *  UITextAttributeTextShadowOffset – 文字阴影偏移量key
 *  @param dic 包含title颜色、字体、阴影的字典
 */
+ (void)setNavigationBarTitleAttribute:(NSDictionary *)dic;
+ (void)setNavigationBarBackImage:(UIImage *)backImage;
/**
 *  设置导航栏按钮标题属性
 *
 *  @param dic 含title颜色、字体、阴影的字典
 */
+ (void)setNavigationBarButtonItemAttribute:(NSDictionary *)dic;

@end
