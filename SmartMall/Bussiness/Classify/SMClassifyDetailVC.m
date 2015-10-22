//
//  SMClassifyDetailVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/19.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMClassifyDetailVC.h"
#import "SMModelCommodity.h"
#import "SMGoodsCell.h"
#import "SMGoodsDetailVC.h"

@interface SMClassifyDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation SMClassifyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createButtons];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createButtons{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.buttonTitles.count * 100, 40)];
    int width = scrollView.frame.size.width/self.buttonTitles.count;
    int height = scrollView.frame.size.height - 0.7;
    for (int i = 0; i < self.buttonTitles.count; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Line_Vertical_Green"]];
        imageView.frame = CGRectMake(width*i - 1, -1.5, 1, height);
        [scrollView addSubview:imageView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(width*i, -1.5, width - 1, height);
        [button setTitle:self.buttonTitles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(turn:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.backgroundColor = [UIColor clearColor];
        [button setTintColor:[UIColor orangeColor]];
        button.enabled = YES;
        [scrollView addSubview:button];
        [self.buttonArray addObject:button];
    }
    //被选中的按钮的背景颜色和字体颜色不一样
    UIButton *button = self.buttonArray[0];
         button.backgroundColor = [UIColor whiteColor];
    [button setTintColor:[UIColor greenColor]];
}

- (void)turn:(UIButton *)button{
    //改变分类
    self.classId = @"";
    [self loadData];
    [self.collectionView reloadData];
}

- (void)loadData{
    NSDictionary *param = @{
                            @"mcEncode":self.mcEncode,
                            @"classId":self.classId,
                            @"limit":@0,
                            @"jump":@0
                            };
    [AVCloud callFunctionInBackground:@"cmGetCmdyList" withParameters:param block:^(NSArray *arr, NSError *error) {
        for (NSDictionary *dic in arr) {
            SMModelCommodity *commodity = [SMModelCommodity objectWithKeyValues:dic];
            [self.dataSource addObject:commodity];
        }
    }];
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SMGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    SMModelCommodity *commodity = self.dataSource[indexPath.row];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:commodity.url]];
    if (data) {
        cell.image.image = [UIImage imageWithData:data];
    }
    cell.price.text = commodity.price;
    cell.name.text = commodity.cmdyEncode;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(self.collectionView.frame.size.width/4 , self.collectionView.frame.size.width/4);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMModelCommodity *commodity = self.dataSource[indexPath.row];
    SMGoodsDetailVC *goodsDetailVC = (SMGoodsDetailVC *)[UIStoryboard instantiateViewControllerWithIdentifier:@"CommedityDetailVC" andStroyBoardNameString:@"Main"];
    goodsDetailVC.mcEncode = self.mcEncode;
    goodsDetailVC.cmdyEncode = commodity.cmdyEncode;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
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