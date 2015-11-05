//
//  SMMerchantCollectionView.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/26.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMMerchantDetailVC.h"

@interface SMMerchantCollectionView : UICollectionView

@property (nonatomic, strong) NSArray *datasource;
@property (nonatomic, strong) SMMerchantDetailVC *controller;
- (void)loadView;

@end
