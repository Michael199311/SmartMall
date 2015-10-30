//
//  HomePageViewController.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/17.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMHomePageViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "SMMerchant.h"
#import "SMMarketListCell.h"
#import "SMMerchantDetailVC.h"
#import "SMHomePageView.h"
#import "SMModelUser.h"

@interface SMHomePageViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (strong, nonatomic) SMHomePageView *tableView;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) CLLocation *checkinLocation;
@property (strong, nonatomic) NSString *currentLatitude; //纬度
@property (strong, nonatomic) NSString *currentLongitude; //经度
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SMHomePageViewController

- (void)dealloc{
    NSLog(@"\n%@ -----> dealloc",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(@80);
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SMMarketListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无法进行定位操作" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self.locManager startUpdatingLocation];
    //NSDictionary *param = @{
                            //@"center":[NSString stringWithFormat:@"%@,%@",self.currentLatitude,self.currentLongitude]
                            //@"center":@"121.597575,31.265437"
                            //};
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"121.597575,31.265437" forKey:@"center"];
    [AVCloud callFunctionInBackground:@"cmGetAroundStoreList" withParameters:param block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"获取附近店铺信息失败:%@",error);
        }else{
            NSLog(@"获取附近店铺信息成功:%@",object);
            NSArray *array = (NSArray *)object;
            for (NSDictionary *dic in array) {
                SMMerchant *merchant = [SMMerchant objectWithKeyValues:dic];
                [self.dataSource addObject:merchant];
            }
            [SMModelUser currentUser].merchants = self.dataSource;
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SMMarketListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    SMMerchant *merchant = self.dataSource[indexPath.row];
    cell.MerchantName.text = merchant._name;
    cell.Distance.text = merchant._distance;
    cell.MiniCost.text = merchant.miniCost;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:merchant._image]];
//    if (data) {
//        cell.ImageView.image = [UIImage imageWithData:data];
//    }
    cell.ImageView.image = [UIImage imageNamed:@"commoditySample"];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 129;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMMerchant *merchant = self.dataSource[indexPath.row];
    UITabBarController *homeController = (UITabBarController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"SMTableBarVC" andStroyBoardNameString:@"Main"];
    SMMerchantDetailVC *MerchantDetailVC = homeController.viewControllers[0];
    MerchantDetailVC.mcEncode = merchant.mcEncode;
    homeController.selectedViewController = MerchantDetailVC;
    [self.navigationController pushViewController:homeController animated:YES];
    //[self presentViewController:homePageVC animated:YES completion:nil];
    //[self.navigationController pushViewController:homeController animated:YES];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.checkinLocation = [locations lastObject];
    CLLocationCoordinate2D cool = self.checkinLocation.coordinate;
    self.currentLatitude  = [NSString stringWithFormat:@"%.6f",cool.latitude];
    self.currentLongitude = [NSString stringWithFormat:@"%.6f",cool.longitude];
    NSLog(@"%@,%@",self.currentLatitude,self.currentLongitude);
}



@end
