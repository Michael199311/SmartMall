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
#import "SMRegisterAndLoginVC.h"

@interface SMHomePageViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
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
    [self.navigationLeftButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"user-male-black-silhouette"] forState:UIControlStateNormal];
    self.title = @"商户列表";
    //重新登录一次，让云端有用户信息
    [self reLogin];
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
    SMMerchantDetailVC *MerchantDetailVC = (SMMerchantDetailVC *)[UIStoryboard instantiateViewControllerWithIdentifier:@"MerchantDetailVC" andStroyBoardNameString:@"Main"];
//    UITabBarController *homeController = (UITabBarController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"SMTableBarVC" andStroyBoardNameString:@"Main"];
//    SMMerchantDetailVC *MerchantDetailVC = homeController.viewControllers[0];
    MerchantDetailVC.mcEncode = merchant.mcEncode;
    //homeController.selectedViewController = MerchantDetailVC;
    [self.navigationController pushViewController:MerchantDetailVC animated:YES];
    //[self presentViewController:homePageVC animated:YES completion:nil];
    //[self.navigationController pushViewController:homeController animated:YES];
}


- (void)reLogin{
    SMModelUser *user = [SMModelUser localUser];
    [AVUser logInWithUsernameInBackground:user.name password:user.password block:^(AVUser *user, NSError *error) {
        if (user) {
            [self getMerchantInfo];
        }else{
            NSLog(@"登录失败");
            [SVProgressHUD showErrorWithStatus:@"登录失败！"];
        }
    }];
}

- (void)getMerchantInfo{
    //NSDictionary *param = @{
    //@"center":[NSString stringWithFormat:@"%@,%@",self.currentLatitude,self.currentLongitude]
    //@"center":@"121.597575,31.265437"
    //};
    NSDictionary *param = [NSDictionary dictionaryWithObject:@"121.597575,31.265437" forKey:@"center"];
    [SVProgressHUD showWithStatus:@"获取附近店铺信息中"];
    [AVCloud callFunctionInBackground:@"cmGetAroundStoreList" withParameters:param block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"获取附近店铺信息失败:%@",error);
            [SVProgressHUD showErrorWithStatus:@"获取附近店铺信息失败"];
        }else{
            NSLog(@"获取附近店铺信息成功:%@",object);
            [SVProgressHUD dismiss];
            NSArray *array = (NSArray *)object;
            for (NSDictionary *dic in array) {
                SMMerchant *merchant = [SMMerchant objectWithKeyValues:dic];
                [self.dataSource addObject:merchant];
            }
            SMModelUser *currentUser = [SMModelUser currentUser];
            currentUser.merchants = self.dataSource;
            [self.tableView reloadData];
        }
    }];
}

- (void)logout{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登出" message:@"确认登出？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [SMModelUser clearUser];
        SMRegisterAndLoginVC *loginController = (SMRegisterAndLoginVC *)[UIStoryboard instantiateViewControllerWithIdentifier:@"RegisterAndLogin" andStroyBoardNameString:@"Main"];
        [loginController.view bringSubviewToFront:loginController.loginView];
        [self presentViewController:loginController animated:YES completion:nil];
    }
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
    NSLog(@"获取到的定位信息:%@,%@",self.currentLatitude,self.currentLongitude);
}



@end
