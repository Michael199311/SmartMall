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
@property (nonatomic, strong) NSMutableArray *imagesArray;
@property (weak, nonatomic) IBOutlet UITextField *receiver;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@end

@implementation SMSubmitOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    count = [SMModelUser currentUser].commoditysArray.count;
    self.amount.text = [NSString stringWithFormat:@"共%lu件",(unsigned long)count];
    //SMModelUser *user = (SMModelUser *)[SMModelUser currentUser];
    //self.name.text = user.defaultConsigneeInfo[@"name"];
    //self.phoneNmuber.text = user.defaultConsigneeInfo[@"phone"];
    //self.address.text = user.defaultConsigneeInfo[@"address"];
    //    for (int i=0; i<user.commoditysArray.count; i++) {
    //        //SMModelCommodity *commodity = user.commoditysArray[i];
    //        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:commodity.url]];
    //        if (data) {
    //            UIImage *image = [UIImage imageWithData:data];
    //            [self.imagesArray addObject:image];
    //        }
    //    }
    //    self.amount.text = [NSString stringWithFormat:@"共%lu件",(unsigned long)user.commoditysArray.count];
    //[self.submitButton makeCornerRadiusOfRadius:10.0f andBorderWidth:1.0f andBorderColor:[UIColor ]]
    // Do any additional setup after loading the view.
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

- (IBAction)submitOrder:(id)sender {
    if (self.receiver.text == nil || self.phoneNumberTextField.text == nil || self.addressTextField.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"信息不完整" message:@"请检查收货信息是否完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //提交订单
        NSMutableArray *cmdys = [[NSMutableArray alloc] init];
        SMModelUser *user = [SMModelUser currentUser];
        NSArray *array = user.commoditysArray;
        for (SMModelCommodity *commodity in array) {
            NSDictionary *dic = @{
                                  @"cmdyEncode":commodity.cmdyEncode,
                                  @"count":@1
                                  };
            [cmdys addObject:dic];
        }
        //NSArray *cmdys = [NSArray arrayWithObjects:cmdy, nil];
        NSDictionary *dic = @{
                              @"mcEncode":@"SH100001",
                              @"consignee":self.receiver.text,
                              @"orderAddress":self.addressTextField.text,
                              @"cPhone":self.phoneNumberTextField.text,
                              @"cmName":user.name,
                              @"cmdys":cmdys
                              };
        NSLog(@"传入的参数:%@",dic);
        [AVCloud callFunctionInBackground:@"cmPlaceAnOrder" withParameters:dic block:^(id object, NSError *error) {
            if (error) {
                NSLog(@"提交订单失败:%@",error);
            }else{
                NSLog(@"提交订单成功:%@",object);
                [SVProgressHUD showSuccessWithStatus:@"提交订单成功"];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
