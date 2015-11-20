//
//  SMShoppingCartVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/20.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMShoppingCartVC.h"
#import "SMShoppingCartCell.h"
#import "SMModelCommodity.h"
#import "SMShoppingCartHeader.h"
#import "UIView+CRAdditions.h"
#import "SMModelUser.h"
#import "SMMerchant.h"
#import "SMSubmitOrderVC.h"
@interface SMShoppingCartVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalCost;
@property (weak, nonatomic) IBOutlet UIButton *payButon;
@property (strong, nonatomic) NSMutableArray *imageArr;
@property (nonatomic, strong) SMButtomNavigater *bottomNavigater;

@end

@implementation SMShoppingCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomNavigater.controller =self;

    self.title = @"购物车";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SMShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [self upDateView];
    [self.tableView reloadData];
    
}

- (IBAction)chooseAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        //选中时要做的事
    }else{
        //未选中时要做的事
    }
}
- (IBAction)pay:(UIButton *)sender {
    SMModelUser *user = [SMModelUser currentUser];
    if (user.commoditysArray.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能结算！" message:@"当前购物车没有物品" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        SMSubmitOrderVC *vc = (SMSubmitOrderVC *)[UIStoryboard instantiateViewControllerWithIdentifier:@"ConfirmOrder" andStroyBoardNameString:@"Main"];
        vc.imageArr = self.imageArr;
        //[self presentViewController:vc animated:YES completion:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self caculateCellCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableArray *arr = self.dataSource[indexPath.row];
    SMModelCommodity *commodity = arr[0];
    //NSArray *commodityArr = self.dataSource[indexPath.row];
    //cell.amount = commodityArr.count;
    //SMModelCommodity *commodity = commodityArr[0];
    
    //    cell.amount = 0;
    //    for (SMModelCommodity *cmdy in self.dataSource) {
    //        if ([cmdy.cmdyEncode isEqualToString:commodity.cmdyEncode]) {
    //            cell.amount ++;
    //        }
    //    }
    
    cell.amount = arr.count;
    cell.count.text = [NSString stringWithFormat:@"%ld",(long)cell.amount];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:commodity.urls.firstObject]];
    UIImage *image = [[UIImage alloc] init];
    if (data) {
        image = [UIImage imageWithData:data];
    }else{
        image = [UIImage imageNamed:@"commoditySample"];
    }
    [self.imageArr addObject:image];
    cell.image.image = image;
    cell.price.text = [commodity.price stringValue];;
    cell.name.text = commodity.cmdyName;
    //[self awakeCellButtonAction:cell andCommodityArr:commodityArr];
    [self awakeCellButtonAction:cell andCommodity:commodity];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    SMShoppingCartHeader *header = [SMShoppingCartHeader loadNibName:@"SMShoppingCartHeader"];
    header.buttonActionBlock = ^(NSDictionary *info,NSInteger type){
        if (type == 0) {
            //选中该section的所有商品
        }
    };
    SMMerchant *merchant = [SMModelUser currentUser].merchants[section];
    header.introduction.text = merchant._name;
    NSString *minCost = merchant.miniCost?merchant.miniCost:@"0";
    header.minCost.text = [NSString stringWithFormat:@"%@起送",minCost];
    return header;
}

- (void)awakeCellButtonAction:(SMShoppingCartCell *)cell andCommodity:(SMModelCommodity *)commodity{
    __weak typeof (self) weakSelf = self;
    __weak typeof (SMShoppingCartCell *) weakCell = cell;
    __weak typeof (SMModelUser *)weakUser = [SMModelUser currentUser];
    //SMModelCommodity *commodity = commodityArr[0];
    cell.buttonActionBlock = ^(NSDictionary *info, NSInteger type){
        switch (type) {
            case 0:
                //选中该cell的商品
                
                break;
            case 1:
                //减去一件该cell的商品
                weakCell.amount --;
                weakCell.count.text = [NSString stringWithFormat:@"%ld",(long)weakCell.amount];
                NSUInteger a = 0;
                for (int i=0; i<weakUser.commoditysArray.count; i++) {
                    SMModelCommodity *cmdy = weakUser.commoditysArray[i];
                    if ([cmdy.cmdyEncode isEqualToString:commodity.cmdyEncode]) {
                        a = i;
                    }
                }
                [weakUser.commoditysArray removeObjectAtIndex:a];
                [weakSelf  upDateView];
                
                break;
            case 2:
                //加一件该cell的商品
                weakCell.amount ++;
                weakCell.count.text = [NSString stringWithFormat:@"%ld",(long)weakCell.amount];
                [weakUser.commoditysArray addObject:commodity];
                [weakSelf upDateView];
                
                break;
            default:
                break;
        }
    };
}


- (NSInteger)caculateCellCount{
    
    NSArray *arr = [SMModelUser currentUser].commoditysArray;
    NSMutableArray *dataSourceCopy = [[NSMutableArray alloc] init];
    int i = 0;
    while (i<arr.count) {
        SMModelCommodity *commodity = arr[i];
        NSMutableArray *cmdyArr = [[NSMutableArray alloc] init];
        for (SMModelCommodity *cmdy in arr) {
            if ([cmdy.cmdyEncode isEqualToString:commodity.cmdyEncode]) {
                [cmdyArr addObject:cmdy];
                i++;
            }
        }
        [dataSourceCopy addObject:cmdyArr];
    }
    self.dataSource = dataSourceCopy;
    return self.dataSource.count;
}

- (void)upDateView{
    double cost = 0;
    int amout = 0;
    //NSArray *commodotys = [SMModelUser currentUser].commoditysArray;
    for (SMModelCommodity *commodity in [SMModelUser currentUser].commoditysArray) {
        //for (SMModelCommodity *commodity in cmdyArr) {
        cost += [commodity.price doubleValue];
        amout ++;
        //}
    }
    self.totalCost.text = [NSString stringWithFormat:@"合计:￥%.2f",cost];
    [self.payButon setTitle:[NSString stringWithFormat:@"去支付(%d)",amout] forState:UIControlStateNormal];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

- (SMButtomNavigater *)bottomNavigater{
    if (!_bottomNavigater) {
        _bottomNavigater = [SMButtomNavigater sharedButtomNavigater];
        _bottomNavigater.frame = CGRectMake(0, self.view.height - 54, self.view.width, 54);
        [self.view addSubview:self.bottomNavigater];
    }
    return _bottomNavigater;
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
