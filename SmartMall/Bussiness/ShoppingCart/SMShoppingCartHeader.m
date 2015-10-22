//
//  SMShoppingCartHeader.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/21.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMShoppingCartHeader.h"

@implementation SMShoppingCartHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)chooseAll:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(nil, 0);
    }
}

@end
