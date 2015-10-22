//
//  SMRegisterView.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/12.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonAction)(NSDictionary *info,NSInteger type);

@interface SMRegisterView : UIView
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *PWTextField;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmPW;
@property (weak, nonatomic) IBOutlet UITextField *securityCode;
@property (copy, nonatomic) buttonAction buttonActionBlock;
@end
