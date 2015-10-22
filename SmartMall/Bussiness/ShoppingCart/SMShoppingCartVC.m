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

@interface SMShoppingCartVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalCost;
@property (weak, nonatomic) IBOutlet UIButton *payButon;

@end

@implementation SMShoppingCartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SMShoppingCartCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view.
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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    SMModelCommodity *commodity = self.dataSource[indexPath.row];
    cell.count.text = [NSString stringWithFormat:@"%ld",(long)cell.amount];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:commodity.url]];
    if (data) {
        cell.image.image = [UIImage imageWithData:data];
    }
    cell.price.text = commodity.price;
    cell.name.text = commodity.cmdyName;
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
    header.introduction.text = @"";
    header.minCost.text = @"";
    return header;
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