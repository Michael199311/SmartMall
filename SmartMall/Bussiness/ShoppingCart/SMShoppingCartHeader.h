//
//  SMShoppingCartHeader.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/21.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^buttonAction)(NSDictionary *info,NSInteger type);

@interface SMShoppingCartHeader : UIView
@property (weak, nonatomic) IBOutlet UILabel *introduction;
@property (weak, nonatomic) IBOutlet UILabel *minCost;
@property (copy, nonatomic) buttonAction buttonActionBlock;

@end
