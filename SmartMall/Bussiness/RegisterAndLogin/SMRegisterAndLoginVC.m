//
//  SMRegisterAndLoginVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/13.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMRegisterAndLoginVC.h"

typedef enum{
    SMWelcomePageTypeRegister = 0,
    SMWelcomePageTypeLogin,
    SMWelcomePageTypeForgetPW
}SMWelcomePageType;

@interface SMRegisterAndLoginVC (){
    SMWelcomePageType WelcomeType;
    UITextField *Phone;
    UITextField *NewPW;
    UITextField *ConfirmPW;
}
@end

@implementation SMRegisterAndLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createView{
    Phone = [[UITextField alloc] init];
    switch (WelcomeType) {
        case SMWelcomePageTypeLogin:
            [self createLoginView];
            break;
        case SMWelcomePageTypeRegister:
            [self createRegisterView];
            break;
        case SMWelcomePageTypeForgetPW:
            [self createForgetPWView];
        default:
            break;
    }
}

- (void)createLoginView{
    
}

- (void)createRegisterView{
    
}

- (void)createForgetPWView{
    
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
