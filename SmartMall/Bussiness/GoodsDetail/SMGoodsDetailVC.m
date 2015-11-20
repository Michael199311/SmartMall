//
//  SMGoodsDetailVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/19.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMGoodsDetailVC.h"
#import "SMModelCommodity.h"
#import "SMShoppingCartVC.h"
#import "SMModelUser.h"

@interface SMGoodsDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCart;
@property (weak, nonatomic) IBOutlet UIButton *addToShoppingCart;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (nonatomic, strong) SMButtomNavigater *bottomNavigater;
@property (strong, nonatomic) SMModelCommodity *commodity;
@end

@implementation SMGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.bottomNavigater.controller =self;

    NSDictionary *param = @{
                            @"mcEncode":self.mcEncode,
                            @"cmdyEncode":self.cmdyEncode
                            };
    [SVProgressHUD showWithStatus:@"获取商品详情中"];
    [AVCloud callFunctionInBackground:@"GetCmdyInfo" withParameters:param block:^(NSDictionary *dic, NSError *error) {
        if (error) {
            NSLog(@"获取商品详情失败");
            [SVProgressHUD showErrorWithStatus:@"获取商品详情失败"];
        }else{
            NSLog(@"获取商品详情成功:%@",dic);
            [SVProgressHUD dismiss];
            self.commodity = [SMModelCommodity objectWithKeyValues:dic];
            [self updateView];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    SMModelUser *user = [SMModelUser currentUser];
    [self.shoppingCart setTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)user.commoditysArray.count] forState:UIControlStateNormal];
}

- (void)updateView{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.commodity.urls.firstObject]];
    if (data) {
        self.image.image = [UIImage imageWithData:data];
    }
    self.price.text = [NSString stringWithFormat:@"￥%@",[self.commodity.price stringValue]] ;
    self.name.text = self.commodity.cmdyName;
}

- (IBAction)turnToShoppingCart:(UIButton *)sender {
//    if (self.dataSource.count != 0) {
//        [[SMModelUser currentUser].commoditysArray addObject:self.dataSource];
//    }
    UINavigationController *vc = (UINavigationController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"shoppingCartNav" andStroyBoardNameString:@"Main"];
    //[self.navigationController pushViewController:homeController animated:YES];
    [self presentViewController:vc animated:YES completion:nil];

    //[self presentViewController:homeController animated:YES completion:nil];
}

- (IBAction)addToShoppingCart:(UIButton *)sender {

    //[self.dataSource addObject:self.commodity];
    SMModelUser *user = [SMModelUser currentUser];
    [user.commoditysArray addObject:self.commodity];
    [SVProgressHUD showSuccessWithStatus:@"添加到购物车成功"];
//    [self.shoppingCart setTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)self.dataSource.count] forState:UIControlStateNormal];
    [self.shoppingCart setTitle:[NSString stringWithFormat:@"购物车(%lu)",(unsigned long)user.commoditysArray.count] forState:UIControlStateNormal];

}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (SMButtomNavigater *)bottomNavigater{
    if (!_bottomNavigater) {
        _bottomNavigater = [SMButtomNavigater sharedButtomNavigater];
        _bottomNavigater.frame = CGRectMake(0, self.view.height - 54, self.view.width, 54);
        [self.view addSubview:self.bottomNavigater];
    }
    return _bottomNavigater;
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
