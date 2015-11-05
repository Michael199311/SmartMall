//
//  UIView+CRAdditions.m
//  CarRental
//
//  Created by 王健功 on 15/7/2.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import "UIView+CRAdditions.h"

@implementation UIView (CRAdditions)

+ loadNibName:(NSString *)nibName
{
	UIView *class = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:0] firstObject];
	return class;
}

- (void)makeCornerRadiusOfRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
}
- (void)makeCornerRadiusOfRadius:(CGFloat)radius andBorderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)borderColor
{
	self.layer.cornerRadius = radius;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
	self.layer.masksToBounds = YES;
}

- (UIViewController*)viewController {
	for (UIView* next = [self superview]; next; next = next.superview) {
		UIResponder* nextResponder = [next nextResponder];
		if ([nextResponder isKindOfClass:[UIViewController class]]) {
			return (UIViewController*)nextResponder;
		}
	}
	return nil;
}
@end
