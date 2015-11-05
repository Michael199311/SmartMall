//
//  SMLoginView.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/13.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMLoginView.h"
@interface SMLoginView()<UITextFieldDelegate>

@end

@implementation SMLoginView
- (IBAction)forgetPW:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(nil,0);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _phoneNumber) {
        [_phoneNumber becomeFirstResponder];
    }else if (textField == _PassWord){
        [_PassWord becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent             *)event{
    [self.phoneNumber resignFirstResponder];
    [self.PassWord resignFirstResponder];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
