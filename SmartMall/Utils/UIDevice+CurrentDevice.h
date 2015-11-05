//
//  UIDevice+CurrentDevice.h
//  CarRentalClient
//
//  Created by 王健功 on 15/6/9.
//  Copyright (c) 2015年 TAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(char, iPhoneModel){
	iPhoneModelIPhone4,//320*480
	iPhoneModelIPhone5,//320*568
	iPhoneModelIPhone6,//375*667
    iPhoneModelIPhone6Plus,//414*736
	UnKnown
};

@interface UIDevice (CurrentDevice)

+ (iPhoneModel)iphoneModel;
/**
 *  系统版本号
 *
 *  @return <#return value description#>
 */
+ (float)getSystemVersion;

@end
