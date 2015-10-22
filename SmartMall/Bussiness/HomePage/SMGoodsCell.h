//
//  SMGoodsCell.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/13.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMGoodsCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
