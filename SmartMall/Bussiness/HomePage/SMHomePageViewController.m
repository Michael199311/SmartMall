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
#import "SMModelUser.h"
#import "SMRegisterAndLoginVC.h"
#import <MapKit/MapKit.h>

@interface SMHomePageViewController ()<CLLocationManagerDelegate,UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *LocationLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (strong, nonatomic) SMHomePageView *tableView;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) CLLocation *checkinLocation;
@property (strong, nonatomic) NSString *currentLatitude; //纬度
@property (strong, nonatomic) NSString *currentLongitude; //经度
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *address;

@end

@implementation SMHomePageViewController

- (void)dealloc{
    NSLog(@"\n%@ -----> dealloc",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationLeftButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationLeftButton setImage:[UIImage imageNamed:@"fetch_back_arrow"] forState:UIControlStateNormal];
    self.title = @"商户列表";
    //重新登录一次，让云端有用户信息
    [self reLogin];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.and.right.and.bottom.mas_equalTo(self.view);
//        make.top.mas_equalTo(@80);
//    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SMMarketListCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locManager = [[CLLocationManager alloc] init];
        self.locManager.delegate = self;
        self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locManager.distanceFilter = 1000.0f;//设备移动更新位置信息的最小距离
        [self.locManager requestAlwaysAuthorization];
        [self.locManager startUpdatingLocation];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法定位" message:@"请在设置中允许该应用使用定位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 1;
        [alert show];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.locManager startUpdatingLocation];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.locManager stopUpdatingLocation];
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
    cell.Address.text = merchant._address;
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:merchant._image]];
//    if (data) {
//        cell.ImageView.image = [UIImage imageWithData:data];
//    }
    //UIImage *image = [UIImage imageNamed:@"commodity"];
    //cell.ImageView.image = image;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 129;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SMMerchant *merchant = self.dataSource[indexPath.row];
    UINavigationController *MerchantNav = (UINavigationController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"homePageNav" andStroyBoardNameString:@"Main"];
//    UITabBarController *homeController = (UITabBarController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"SMTableBarVC" andStroyBoardNameString:@"Main"];
//    SMMerchantDetailVC *MerchantDetailVC = homeController.viewControllers[0];
    SMMerchantDetailVC *MerchantDetailVC = (SMMerchantDetailVC *)MerchantNav.topViewController;
    MerchantDetailVC.mcEncode = merchant.mcEncode;
    [self presentViewController:MerchantDetailVC animated:YES completion:nil];
}


- (void)reLogin{
    SMModelUser *localUser = [SMModelUser localUser];
    NSLog(@"传入的参数:userName:%@,password:%@",localUser.name,localUser.password);
    [AVUser logInWithUsernameInBackground:localUser.name password:localUser.password block:^(AVUser *user, NSError *error) {
        if (user) {
            [self getMerchantInfo];
        }else{
            NSLog(@"登录失败");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法加载数据" message:@"缺少用户信息，请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            //[SVProgressHUD showErrorWithStatus:@"缺少用户信息，请重新登录！"];
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
    alert.tag = 0;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0 && buttonIndex == 1) {
        [SMModelUser clearUser];
        SMRegisterAndLoginVC *loginController = (SMRegisterAndLoginVC *)[UIStoryboard instantiateViewControllerWithIdentifier:@"RegisterAndLogin" andStroyBoardNameString:@"Main"];
        [loginController.view bringSubviewToFront:loginController.loginView];
        [self presentViewController:loginController animated:YES completion:nil];
    }else if (alertView.tag == 1 && buttonIndex == 0){
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位出错:%@",error);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法定位" message:@"请在设置中允许该应用使用定位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [self.locManager stopUpdatingLocation];
    
}



-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    if (locations.count>0) {
        self.checkinLocation = [locations lastObject];
        CLLocationCoordinate2D cool = self.checkinLocation.coordinate;
        self.currentLatitude  = [NSString stringWithFormat:@"%.6f",cool.latitude];
        self.currentLongitude = [NSString stringWithFormat:@"%.6f",cool.longitude];
        NSLog(@"获取到的定位信息:%@,%@",self.currentLatitude,self.currentLongitude);
        //获取当前所在地址
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.checkinLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (placemarks.count>0) {
                CLPlacemark *place = placemarks[0];
                NSString *city = place.locality;
                if (!city) {
                    city = place.administrativeArea;
                }
                NSLog(@"name:%@",place.name);
                NSLog(@"thoroughfare:%@",place.thoroughfare);
                NSLog(@"subThoroughfare:%@",place.subThoroughfare);
                NSLog(@"locality:%@",place.locality);
                NSLog(@"subLocality:%@",place.subLocality);
                NSLog(@"administrativeArea:%@",place.administrativeArea);
                NSLog(@"subAdministrativeArea:%@",place.subAdministrativeArea);
                NSLog(@"postalCode:%@",place.postalCode);
                NSLog(@"ISOcountryCode:%@",place.ISOcountryCode);
                NSLog(@"country:%@",place.country);
                
                NSLog(@"inlandWater:%@",place.inlandWater);
                NSLog(@"ocean:%@",place.ocean);
                
                self.address = city;
                self.LocationLabel.text = [NSString stringWithFormat:@"%@%@%@%@",place.locality,place.subLocality,place.thoroughfare,place.subThoroughfare];
            }else{
                [SVProgressHUD showErrorWithStatus:@"获取地址信息失败"];
                [self.locManager stopUpdatingLocation];
            }
            
        }];

    }else{
        [SVProgressHUD showErrorWithStatus:@"获取定位信息失败"];
        [self.locManager stopUpdatingLocation];
    }
    
}



@end
