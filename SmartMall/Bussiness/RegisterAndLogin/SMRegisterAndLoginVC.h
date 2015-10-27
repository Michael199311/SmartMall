//
//  SMRegisterAndLoginVC.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/13.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRBaseViewController.h"
#import "SMLoginView.h"
#import "SMRegisterView.h"
#import "SMForgetPWView.h"
@interface SMRegisterAndLoginVC : UIViewController

@property (nonatomic, strong) SMLoginView *loginView;
@property (nonatomic, strong) SMRegisterView *registerView;
@property (nonatomic, strong) SMForgetPWView *forgetPWView;


@end
