//
//  SMRegisterView.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/12.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMRegisterView.h"
@interface SMRegisterView()<UITextFieldDelegate>

@end

@implementation SMRegisterView

- (void)didMoveToSuperview{
    //[self.checkButton makeCornerRadiusOfRadius:1.0 andBorderWidth:10.0 andBorderColor:[UIColor whiteColor]];
}

- (IBAction)checkSecurityCode:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(nil,0);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _phoneNumber) {
        [_phoneNumber becomeFirstResponder];
    }else if (textField == _PWTextField){
        [_PWTextField becomeFirstResponder];
    }else if (textField == _ConfirmPW){
        [_ConfirmPW becomeFirstResponder];
    }else if (textField == _securityCode){
        [_securityCode becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent             *)event{
    [self.phoneNumber resignFirstResponder];
    [self.PWTextField resignFirstResponder];
    [self.ConfirmPW resignFirstResponder];
    [self.securityCode resignFirstResponder];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
