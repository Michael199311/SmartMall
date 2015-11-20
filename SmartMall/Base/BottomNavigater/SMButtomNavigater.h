//
//  SMButtomNavigater.h
//  SmartMall
//
//  Created by Codger on 15/11/18.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIStoryboard+CRInstantiate.h"

@interface SMButtomNavigater : UIView

@property (nonatomic, strong) UIViewController *controller;
+ (SMButtomNavigater *)sharedButtomNavigater;

@end
