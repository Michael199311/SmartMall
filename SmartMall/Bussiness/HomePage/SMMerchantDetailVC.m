//
//  SMMerchantDetailVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/19.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMMerchantDetailVC.h"
#import "SMModelCommodity.h"
#import "SMGoodsDetailVC.h"
#import "SMGoodsCell.h"

@interface SMMerchantDetailVC ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *adImgDatasource;

@end

@implementation SMMerchantDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取该商店的数据
//    NSDictionary *param = @{
//                            //@"mcEncode":self.mcEncode
//                            @"mcEncode":@"SH100001"
//                            };
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"SH100001" forKey:@"mcEncode"];
    [AVCloud callFunctionInBackground:@"cmGetStoreMain" withParameters:param block:^(NSDictionary *dic, NSError *error) {
        if (error) {
            NSLog(@"获取店铺详情失败:%@",error);
        }else{
            self.dataSource = dic[@"cmdys"][@"cmdys"];
            self.adImgDatasource = dic[@"adImg"][@"adImg"];
        }
        //[self.collectionView reloadData];
    }];
   // [self.collectionView registerNib:[UINib nibWithNibName:@"SMGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    
}

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    NSLog(@"当前元素个数:%lu",(unsigned long)self.dataSource.count);
//    return self.dataSource.count;
//    //return 1;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    SMGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    SMModelCommodity *commodity = self.dataSource[indexPath.row];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:commodity.url]];
//    if (data) {
//        cell.image.image = [UIImage imageWithData:data];
//    }
//    cell.price.text = commodity.price;
//    cell.name.text = commodity.cmdyName;
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    
//    return CGSizeMake(self.collectionView.frame.size.width/4 , self.collectionView.frame.size.width/4);
//}
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
//    return UIEdgeInsetsMake(0, 0, 0, 0);
//}
//
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    SMModelCommodity *commodity = self.dataSource[indexPath.row];
//    SMGoodsDetailVC *goodsDetailVC = (SMGoodsDetailVC *)[UIStoryboard instantiateViewControllerWithIdentifier:@"CommedityDetailVC" andStroyBoardNameString:@"Main"];
//    goodsDetailVC.mcEncode = self.mcEncode;
//    goodsDetailVC.cmdyEncode = commodity.cmdyEncode;
//    [self.navigationController pushViewController:goodsDetailVC animated:YES];
//}
//

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)adImgDatasource{
    if (!_adImgDatasource) {
        _adImgDatasource = [[NSMutableArray alloc] init];
    }
    return _adImgDatasource;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
