//
//  SMMarketListCell.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/13.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMMarketListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *MerchantName;
@property (weak, nonatomic) IBOutlet UILabel *MiniCost;
@property (weak, nonatomic) IBOutlet UILabel *Address;
@property (weak, nonatomic) IBOutlet UILabel *Distance;
@property (weak, nonatomic) IBOutlet UILabel *OrderNumber;
@property (weak, nonatomic) IBOutlet UILabel *Kinds;

@end
