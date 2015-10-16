//
//  UIDevice+CurrentDevice.m
//  CarRentalClient
//
//  Created by 王健功 on 15/6/9.
//  Copyright (c) 2015年 TAC. All rights reserved.
//

#import "UIDevice+CurrentDevice.h"

@implementation UIDevice (CurrentDevice)

+ (iPhoneModel)iphoneModel
{
	CGRect bounds  = [UIScreen mainScreen].bounds;
	CGFloat width= bounds.size.width;
	CGFloat height = bounds.size.height;
	//get current interface Orientation
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationUnknown) {
		return UnKnown;
	}
	//    portrait   width * height
	//    iPhone4:320*480
	//    iPhone5:320*568
	//    iPhone6:375*667
	//    iPhone6Plus:414*736
	//portrait
	if (UIInterfaceOrientationPortrait == orientation) {
		if (width ==  320.0f) {
			if (height == 480.0f) {
                 return iPhoneModelIPhone4;
             } else {
                 return iPhoneModelIPhone5;
             }
         } else if (width == 375.0f) {
             return iPhoneModelIPhone6;
         } else if (width == 414.0f) {
             return iPhoneModelIPhone6Plus;
		 }
     } else if (UIInterfaceOrientationLandscapeLeft == orientation || UIInterfaceOrientationLandscapeRight == orientation) {
		 //landscape
         if (height == 320.0) {
             if (width == 480.0f) {
                 return iPhoneModelIPhone4;
             } else {
                 return iPhoneModelIPhone5;
             }
         } else if (height == 375.0f) {
             return iPhoneModelIPhone6;
         } else if (height == 414.0f) {
             return iPhoneModelIPhone6Plus;
		 }
     }

     return UnKnown;
}

+ (float)getSystemVersion
{
	return [[[UIDevice currentDevice] systemVersion] floatValue];
}

@end
