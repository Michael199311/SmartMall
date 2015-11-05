//
//  SMShoppingCartCell.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/14.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMShoppingCartCell.h"

@implementation SMShoppingCartCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)choose:(UIButton *)sender {
    //改变按钮的背景颜色为红色
    if (self.buttonActionBlock) {
        self.buttonActionBlock(nil, 0);
    }
}

- (IBAction)reduce:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(nil, 1);
    }
}
- (IBAction)add:(UIButton *)sender {
    if (self.buttonActionBlock) {
        self.buttonActionBlock(nil, 2);
    }
}

@end
