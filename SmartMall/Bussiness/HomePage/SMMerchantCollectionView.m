//
//  SMMerchantCollectionView.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/26.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMMerchantCollectionView.h"
#import "SMGoodsCell.h"
#import "SMModelCommodity.h"
#import "SMGoodsDetailVC.h"

@interface SMMerchantCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>


@end


@implementation SMMerchantCollectionView

- (void)loadView{
    [self registerNib:[UINib nibWithNibName:@"SMGoodsCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    self.delegate = self;
    self.dataSource = self;
    [self reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSLog(@"当前元素个数:%lu",(unsigned long)self.datasource.count);
    return self.datasource.count;
    //return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SMGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    SMModelCommodity *commodity = self.datasource[indexPath.row];
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
    
    return CGSizeMake(self.frame.size.width/4 , self.frame.size.width/4);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={[UIScreen mainScreen].bounds.size.width,44};
    return size;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SMModelCommodity *commodity = self.datasource[indexPath.row];
    SMGoodsDetailVC *goodsDetailVC = (SMGoodsDetailVC *)[UIStoryboard instantiateViewControllerWithIdentifier:@"CommedityDetailVC" andStroyBoardNameString:@"Main"];
    goodsDetailVC.mcEncode = @"SH100001";
    goodsDetailVC.cmdyEncode = commodity.cmdyEncode;
    [self.controller.navigationController pushViewController:goodsDetailVC animated:YES];
    
}


- (NSArray *)datasource{
    if (!_datasource) {
        _datasource = [[NSArray alloc] init];
    }
    return _datasource;
}

@end
