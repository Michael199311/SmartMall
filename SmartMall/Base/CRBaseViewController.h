//
//  CRBaseViewController.h
//  CarRentalClient
//
//  Created by 王健功 on 15/6/9.
//  Copyright (c) 2015年 TAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVOSCloud/AVOSCloud.h>
#import "UIStoryboard+CRInstantiate.h"
#import "NSObject+MJKeyValue.h"

@class CRNavigationBarView;

typedef void (^CRHeadButtonAction)(UIButton *actionButton);

@interface CRBaseViewController : UIViewController

/**
 *  设置背景颜色
 */
@property (strong, nonatomic) UIColor *backgroundColor;
/**
 *  设置背景图片
 */
@property (strong, nonatomic) UIImage *backgroundImage;
/**
 *  设置左侧按钮图片
 */
@property (strong, nonatomic) UIImage *leftBarImage;
/**
 *  导航栏左侧view
 */
@property (strong, nonatomic) UIButton *navigationLeftButton;
/**
 *  导航栏右侧view
 */
@property (strong, nonatomic) UIButton *navigationRightButton;
/**
 *  设置右侧按钮图片
 */
@property (strong, nonatomic) NSString *rightBarImageString;
/**
 *  设置导航栏标题，id类型，默认是图片
 */
@property (strong, nonatomic) id navigationTitle;
/**
 *  可以被子类重用
 */
- (void)leftButtonAction;
- (void)rightButtonAction;

@end
