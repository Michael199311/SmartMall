//
//  UINavigationController+CRCustomNavigationController.m
//  CarRental
//
//  Created by 王健功 on 15/7/1.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import "UINavigationController+CRCustomNavigationController.h"

@implementation UINavigationController (CRCustomNavigationController)

+ (void)setNavigationBarBackgroundImage:(UIImage *)backgroundImage
{
	[[UINavigationBar appearance] setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

+ (void)setNavigationBarBackgroundColor:(UIColor *)backgourndColor
{
	[[UINavigationBar appearance] setBarTintColor:backgourndColor];
}

+ (void)setNavigationBarTitleAttribute:(NSDictionary *)dic
{
	[[UINavigationBar appearance] setTitleTextAttributes:dic];
}

+ (void)setNavigationBarBackImage:(UIImage *)backImage
{
	[[UINavigationBar appearance] setBackIndicatorImage:backImage];
}

+ (void)setNavigationBarButtonItemAttribute:(NSDictionary *)dic
{
	[[UIBarButtonItem appearance] setTitleTextAttributes:dic forState:UIControlStateNormal];
}

@end
