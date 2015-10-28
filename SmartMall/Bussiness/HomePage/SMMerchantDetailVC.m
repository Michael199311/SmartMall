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
#import "CRDataSotreManage.h"
#import "SMMerchantCollectionView.h"

#define kCount 6  //图片总张数

static long step = 0; //记录时钟动画调用次数

@interface SMMerchantDetailVC ()<UIScrollViewDelegate>{
    UIImageView     *_currentImageView; //当前视图
    UIImageView     *_nextImageView;    //下一个视图
    UIImageView     *_previousView;     //上一个视图
    CADisplayLink   *_timer;            //定时器
    BOOL _isDraging; //当前是否正在拖拽
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) SMMerchantCollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *adImgDatasource;

@end

@implementation SMMerchantDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.scrollView];
    //[self createFakeData];
    
    //获取该商店的数据
    NSDictionary *param = @{
                            @"mcEncode":self.mcEncode
                            };
    NSLog(@"传入的参数为:%@",param);
    [AVCloud callFunctionInBackground:@"cmGetStoreMain" withParameters:param block:^(NSDictionary *dic, NSError *error) {
        if (error) {
            NSLog(@"获取店铺详情失败:%@",error);
        }else{
            NSLog(@"获取的店铺详情信息:%@",dic);
            NSArray *cmdys = dic[@"cmdys"];
            for (NSDictionary *dic in cmdys) {
                SMModelCommodity *commodity = [SMModelCommodity objectWithKeyValues:dic];
                [self.dataSource addObject:commodity];
            }
            NSArray *array = dic[@"adImg"];
            for (NSString *url in array) {
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                UIImage *image;
                if (data) {
                    image = [UIImage imageWithData:data];
                }else{
                    image = [UIImage imageNamed:@"commoditySample"];
                }
                [self.adImgDatasource addObject:image];
            }
            self.collectionView.datasource = self.dataSource;
            self.collectionView.controller = self;
            [self.collectionView loadView];
        }
        [self initImageView];
        [self.collectionView reloadData];
    }];
    
    
    
}

- (void)createFakeData{
    NSDictionary *fakeCmdys = @{
                                @"cmdyName":@"天地粮人",
                                @"price":@39.8,
                                @"disPrice":@20,
                                @"cmdyEncode":@"D0103002",
                                @"stock":@"49",
                                @"url":@"http://ac-pcyalv4v.clouddn.com/83eb42a4-e0ec-c000-feb6-327e5ac386f7.png"
                                };
    NSArray *fakeImages = @[@"http://ac-pcyalv4v.clouddn.com/8c25875e-83b1-22cf-be27-e77b079f3cca.png",
                            @"http://ac-pcyalv4v.clouddn.com/8c25875e-83b1-22cf-be27-e77b079f3cca.png",
                            @"http://ac-pcyalv4v.clouddn.com/8c25875e-83b1-22cf-be27-e77b079f3cca.png"];
    NSDictionary *fakeData = @{
                               @"cmdys":@[fakeCmdys],
                               @"adImg":fakeImages
                               };
    NSArray *cmdys = fakeData[@"cmdys"];
    for (NSDictionary *dic in cmdys) {
        SMModelCommodity *commodity = [SMModelCommodity objectWithKeyValues:dic];
        [self.dataSource addObject:commodity];
    }
    NSArray *array = fakeData[@"adImg"];
    for (NSString *url in array) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            [self.adImgDatasource addObject:image];
        }
    }
    self.collectionView.datasource = self.dataSource;
    self.collectionView.controller = self;
    [self initImageView];
    [self.collectionView loadView];
}

- (void)initImageView{
    CGFloat width = self.view.width;
    CGFloat height = 100;
    //初始化当前视图
    _currentImageView = [[UIImageView alloc] init];
    //_currentImageView.image = [UIImage imageNamed:@"commodity3"];
    _currentImageView.image = self.adImgDatasource[0];
    _currentImageView.frame = CGRectMake(width, 0, width, height);
    _currentImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_currentImageView];
    //初始化下一个视图
    _nextImageView = [[UIImageView alloc] init];
    //_nextImageView.image = [UIImage imageNamed:@"commodity1"];
    _nextImageView.image = self.adImgDatasource[0];
    _nextImageView.frame = CGRectMake(width * 2, 0, width, height);
    _nextImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_nextImageView];
    //初始化上一个视图
    _previousView = [[UIImageView alloc] init];
    //_previousView.image = [UIImage imageNamed:@"commodity2"];
    _previousView.image = self.adImgDatasource[0];
    _previousView.frame = CGRectMake(0, 0, width, height);
    _previousView.contentMode = UIViewContentModeScaleAspectFill;
    [_scrollView addSubview:_previousView];
    // 时钟动画
    //_timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(update:)];
    //[_timer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark - 时钟动画调用方法
- (void)update:(CADisplayLink *)timer{
    step ++;
    CGFloat width = self.view.width;
    if ((step % 120 != 0) || _isDraging) {
        return;
    }
    CGPoint offset = _scrollView.contentOffset;
    
    offset.x += width;
    if (offset.x > width*2) {
        offset.x = width;
    }
    
    [_scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 代理方法
#pragma mark 准备开始拖动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _isDraging = YES;
}

#pragma mark 视图停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isDraging = NO;
    step = 0;
}

#pragma mark 已经拖动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    static int i = 1;//当前展示的是第几张图片
    
    float offset = scrollView.contentOffset.x;
    if (_nextImageView.image == nil || _previousView.image == nil) {
        
        //加载下一个视图
        NSString *imageName1 = [NSString stringWithFormat:@"0%d.jpg", i == kCount ? 1 : i + 1];
        _nextImageView.image = [UIImage imageNamed:imageName1];
        
        //加载上一个视图
        NSString *imageName2 = [NSString stringWithFormat:@"0%d.jpg", i == 1 ? kCount : i - 1];
        _previousView.image = [UIImage imageNamed:imageName2];
    }
    if (offset == 0) {
        _currentImageView.image = _previousView.image;
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        _previousView.image = nil;
        
        if (i == 1) {
            i = kCount;
        }else{
            i -= 1;
        }
        
    }
    
    if (offset == scrollView.bounds.size.width * 2) {
        _currentImageView.image = _nextImageView.image;
        scrollView.contentOffset = CGPointMake(scrollView.bounds.size.width, 0);
        _nextImageView.image = nil;
        
        if (i == kCount) {
            i = 1;
        }else{
            i += 1;
        }
        
    }
}

- (SMMerchantCollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
        _collectionView = [[SMMerchantCollectionView alloc] initWithFrame:CGRectMake(0, 316, self.view.width, self.view.height - 216) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

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

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        CGFloat width = self.view.width;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 66, width, 250)];
        _scrollView.contentSize = CGSizeMake(3 * width, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.contentOffset = CGPointMake(width, 0);
    }
    return _scrollView;
}

- (NSString *)mcEncode{
    if (!_mcEncode) {
        _mcEncode = @"SH100001";
    }
    return _mcEncode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
