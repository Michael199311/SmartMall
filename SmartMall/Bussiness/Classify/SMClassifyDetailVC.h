//
//  SMClassifyDetailVC.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/19.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "CRBaseViewController.h"

@interface SMClassifyDetailVC : CRBaseViewController

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSArray *buttonTitles;
@property (strong, nonatomic) NSString *classId;
@property (strong, nonatomic) NSString *mcEncode;

@end
