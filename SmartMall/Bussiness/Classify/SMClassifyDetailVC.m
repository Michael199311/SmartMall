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

@interface SMClassifyDetailVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
@property (strong, nonatomic) NSMutableArray *buttonArray;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SMButtomNavigater *bottomNavigater;


@end

@implementation SMClassifyDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomNavigater.controller =self;

    self.title = @"详细分类";

    //[self createButtons];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createButtons{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 40)];
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(100*self.buttonTitles.count, 40);
    scrollView.backgroundColor = [UIColor orangeColor];
    [scrollView flashScrollIndicators];
    scrollView.pagingEnabled = YES;
    // 是否同时运动,lock
    scrollView.directionalLockEnabled = YES;
    [self.view addSubview:scrollView];
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
        button.backgroundColor = [UIColor greenColor];
        [button setTintColor:[UIColor grayColor]];
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
}

- (void)loadData{
    NSDictionary *param = @{
                            @"mcEncode":self.mcEncode,
                            @"classId":self.classId,
                            @"limit":@0,
                            @"jump":@0
                            };
    [SVProgressHUD showWithStatus:@"获取商品列表中"];
    [AVCloud callFunctionInBackground:@"cmGetCmdyList" withParameters:param block:^(NSArray *arr, NSError *error) {
        if (error) {
            NSLog(@"获取商品列表失败:%@",error);
            [SVProgressHUD showErrorWithStatus:@"获取商品列表失败"];
        }else{
            NSLog(@"获取商品列表成功:%@",arr);
            if (arr.count == 0) {
                [SVProgressHUD showErrorWithStatus:@"该分类暂时还没有商品"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [SVProgressHUD dismiss];
                for (NSDictionary *dic in arr) {
                    SMModelCommodity *commodity = [SMModelCommodity objectWithKeyValues:dic];
                    [self.dataSource addObject:commodity];
                }
                [self.collectionView reloadData];
            }
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
    }else{
        cell.image.image = [UIImage imageNamed:@"commoditySample"];
    }
    cell.price.text = [commodity.price stringValue];;
    cell.name.text = commodity.cmdyName;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(119 , 222);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={self.view.width,44};
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMModelCommodity *commodity = self.dataSource[indexPath.row];
    SMGoodsDetailVC *goodsDetailVC = (SMGoodsDetailVC *)[UIStoryboard instantiateViewControllerWithIdentifier:@"CommedityDetailVC" andStroyBoardNameString:@"Main"];
    goodsDetailVC.mcEncode = self.mcEncode;
    goodsDetailVC.cmdyEncode = commodity.cmdyEncode;
    [self.navigationController pushViewController:goodsDetailVC animated:YES];
    //[self presentViewController:goodsDetailVC animated:YES completion:nil];
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
