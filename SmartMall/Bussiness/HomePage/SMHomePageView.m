//
//  SMHomePageView.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/22.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMHomePageView.h"
#import "SMMarketListCell.h"
#import "SMMerchant.h"
@interface SMHomePageView()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation SMHomePageView

- (void)dealloc{
 NSLog(@"\n%@ -----> dealloc",[self class]);
}

- (void)loadView{
    [self registerNib:[UINib nibWithNibName:@"SMMarketListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.backgroundColor = [UIColor clearColor];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = self;
    self.delegate = self;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMMarketListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    SMMerchant *merchant = self.dataSource[indexPath.row];
    cell.MerchantName.text = merchant._name;
    cell.Distance.text = merchant._distance;
    cell.MiniCost.text = merchant.miniCost;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:merchant._image]];
    if (data) {
        cell.ImageView.image = [UIImage imageWithData:data];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 129;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (NSMutableArray *)datasource{
    if (!_datasource) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}


@end
