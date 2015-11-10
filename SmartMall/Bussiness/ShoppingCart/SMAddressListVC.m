//
//  SMAddressListVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/21.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMAddressListVC.h"

@interface SMAddressListVC ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;

@end

@implementation SMAddressListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"地址列表";

    // Do any additional setup after loading the view.
}
- (IBAction)changeAddress:(UIButton *)sender {
    //改变地址信息
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
