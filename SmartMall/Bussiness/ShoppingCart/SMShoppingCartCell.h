//
//  SMShoppingCartCell.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/14.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonAction)(NSDictionary *info,NSInteger type);


@interface SMShoppingCartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *chooseState;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *count;
@property (assign, nonatomic) NSInteger amount;
@property (copy, nonatomic) buttonAction buttonActionBlock;
@end
