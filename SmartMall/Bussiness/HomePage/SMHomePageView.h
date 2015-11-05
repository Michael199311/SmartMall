//
//  SMHomePageView.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/22.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMHomePageView : UITableView

@property (nonatomic, strong) NSMutableArray *datasource;
- (void)loadView;

@end
