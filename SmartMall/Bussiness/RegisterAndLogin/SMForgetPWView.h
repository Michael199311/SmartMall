//
//  SMForgetPWView.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/13.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonAction)(NSDictionary *info,NSInteger type);
@interface SMForgetPWView : UIView

@property (nonatomic, copy) buttonAction buttonActionBlock;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *createPW;
@property (weak, nonatomic) IBOutlet UITextField *confirmPW;
@property (weak, nonatomic) IBOutlet UITextField *securityCode;
@end
