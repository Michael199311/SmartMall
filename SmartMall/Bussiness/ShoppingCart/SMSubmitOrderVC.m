//
//  SMSubmitOrderVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/21.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMSubmitOrderVC.h"
#import "SMModelUser.h"
#import "SMModelCommodity.h"
#import "SMMerchantDetailVC.h"
#import "SMMerchant.h"

@interface SMSubmitOrderVC ()<UITextFieldDelegate>
{
    NSInteger count;
}
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phoneNmuber;
@property (weak, nonatomic) IBOutlet UIImageView *defaultImageView;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *imag2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *payWay;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *receiver;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (nonatomic, strong) SMButtomNavigater *bottomNavigater;

@end

@implementation SMSubmitOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bottomNavigater.controller =self;

    [self updateUI];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _receiver) {
        [_receiver becomeFirstResponder];
    }else if (textField == _phoneNumberTextField){
        [_phoneNumberTextField becomeFirstResponder];
    }else if (textField == _addressTextField){
        [_addressTextField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent             *)event{
    [self.receiver resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.addressTextField resignFirstResponder];
    
}

- (BOOL)checkTextField{
    NSLog(@"收货人:%@,手机号码:%@,收货地址:%@",self.receiver.text,self.phoneNumberTextField.text,self.addressTextField.text);
    if (![NSString isNotEmptyString:self.receiver.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入收货人信息"];
        return NO;
    }else if (![NSString isNotEmptyString:self.phoneNumberTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入收货人手机号码"];
        return NO;
    }else if (![NSString isNotEmptyString:self.addressTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入收货地址信息"];
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)submitOrder:(id)sender {
    if ([self checkTextField]) {
        //提交订单
        NSMutableArray *cmdys = [[NSMutableArray alloc] init];
        SMModelUser *user = [SMModelUser currentUser];
        NSString *name = [SMModelUser localUser].name;
       // NSArray *array = user.commoditysArray;
        for (SMModelCommodity *commodity in user.commoditysArray) {
            //SMModelCommodity *commodity = commoditys[0];
            NSDictionary *dic = @{
                                  @"cmdyEncode":commodity.cmdyEncode,
                                  @"count":@1
                                  };
            [cmdys addObject:dic];
        }
        NSDictionary *dic = @{
                              @"mcEncode":@"SH100001",
                              @"consignee":self.receiver.text,
                              @"orderAddress":self.addressTextField.text,
                              @"cPhone":self.phoneNumberTextField.text,
                              @"cmName":name,
                              @"cmdys":cmdys
                              };
        NSLog(@"传入的参数:%@",dic);
        [SVProgressHUD showWithStatus:@"提交订单中"];
        UIButton *button = (UIButton *)sender;
        button.enabled = NO;
        [AVCloud callFunctionInBackground:@"cmPlaceAnOrder" withParameters:dic block:^(id object, NSError *error) {
            button.enabled = YES;
            if (error) {
                NSLog(@"提交订单失败:%@",error);
                [SVProgressHUD showErrorWithStatus:@"订单提交失败"];
            }else{
                NSLog(@"提交订单成功:%@",object);
                [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
                UITabBarController *homeController = (UITabBarController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"SMTableBarVC" andStroyBoardNameString:@"Main"];
//                SMMerchantDetailVC *MerchantDetailVC = homeController.viewControllers[0];
//                SMMerchant *merchant = [SMModelUser currentUser].merchants[0];
//                MerchantDetailVC.mcEncode = merchant.mcEncode;
                homeController.selectedViewController = homeController.viewControllers[0];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:homeController animated:YES];
                });
                [user.commoditysArray removeAllObjects];

            }
        }];
}
    }

- (void)updateUI{
    self.title = @"订单确认";
    count = [SMModelUser currentUser].commoditysArray.count;
    self.amount.text = [NSString stringWithFormat:@"共%lu件",(unsigned long)count];
    if (self.imageArr[0]) {
        self.image1.image = self.imageArr[0];
    }
    if (self.imageArr[1]) {
        self.imag2.image = self.imageArr[1];
    }
    if (self.imageArr[2]) {
        self.image3.image = self.imageArr[2];
    }
    
}

- (NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
