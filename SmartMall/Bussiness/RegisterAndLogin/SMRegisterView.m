//
//  SMRegisterView.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/12.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMRegisterView.h"
@interface SMRegisterView()

@end

@implementation SMRegisterView
- (IBAction)checkSecurityCode:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(nil,0);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
