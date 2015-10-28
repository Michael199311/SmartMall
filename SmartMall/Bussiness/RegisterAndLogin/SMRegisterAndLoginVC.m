//
//  SMRegisterAndLoginVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/13.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMRegisterAndLoginVC.h"

#import "UIView+CRAdditions.h"
#import "SMHomePageViewController.h"
#import "UIStoryboard+CRInstantiate.h"
#import "SMMerchantDetailVC.h"
#import "SMModelUser.h"
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
    UIView *statusView;
    __weak IBOutlet UIButton *registerButton;
    __weak IBOutlet UIButton *loginButton;
    
    __weak IBOutlet UIButton *finishButton;
    
}

@end

@implementation SMRegisterAndLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    WelcomeType = SMWelcomePageTypeLogin;
    statusView = [[UIView alloc] init];
    statusView.frame = CGRectMake(loginButton.x , loginButton.y + loginButton.height +1, loginButton.width, 1);
    statusView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:statusView];
    [self createView];
    [self activeButtonAction];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)turnRegisterView:(UIButton *)sender {
    WelcomeType = SMWelcomePageTypeRegister;
    statusView.frame = CGRectMake(sender.x, sender.y + sender.height +1, sender.width, 1);
    [self createView];
}

- (IBAction)turnLoginView:(UIButton *)sender {
    statusView.frame = CGRectMake(sender.x, sender.y + sender.height +1, sender.width, 1);
    WelcomeType = SMWelcomePageTypeLogin;
    [self createView];
}

- (IBAction)finish:(UIButton *)sender {
    switch (WelcomeType) {
        case SMWelcomePageTypeLogin:
            //登录
            [self login];
            break;
        case SMWelcomePageTypeRegister:
            //注册
            [self registerNewUser];
            break;
        case SMWelcomePageTypeForgetPW:
            //提交新密码
            [self resetPassword];
            break;
        default:
            break;
    }
}

- (void)login{
    NSString *username = self.loginView.phoneNumber.text;
    NSString *password = self.loginView.PassWord.text;
    [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        if (user != nil) {
            NSLog(@"登录成功");
            //保存用户信息
            [AVUser changeCurrentUser:user save:YES];
            
            SMModelUser *SMUser = [SMModelUser currentUser];
            SMUser.name = username;
            SMUser.phoneNumber = username;
            //[SMModelUser saveUserToLocalWithUser:SMUser];
            //进入首页
            SMHomePageViewController *homePageVC = (SMHomePageViewController  *)[UIStoryboard instantiateViewControllerWithIdentifier:@"HomePageVC" andStroyBoardNameString:@"Main"];
            [self.navigationController pushViewController:homePageVC animated:YES];
//            UITabBarController *homeController = (UITabBarController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"SMTableBarVC" andStroyBoardNameString:@"Main"];
//            homeController.selectedViewController = homeController.viewControllers[0];
//            [self.navigationController pushViewController:homeController animated:YES];
            
            
//            SMMerchantDetailVC *merchentDetailVC = (SMMerchantDetailVC  *)[UIStoryboard instantiateViewControllerWithIdentifier:@"MerchantDetailVC" andStroyBoardNameString:@"Main"];
//            merchentDetailVC.mcEncode = @"SH100001";
//            //[self.navigationController pushViewController:merchentDetailVC animated:YES];
//            [self presentViewController:merchentDetailVC animated:YES completion:nil];
        }else{
            NSLog(@"登录失败");
        }
        
    }];
}

- (void)registerNewUser{
    AVUser *user = [AVUser user];
    user.username = self.registerView.phoneNumber.text;
    user.password = self.registerView.PWTextField.text;
    user.mobilePhoneNumber = self.registerView.phoneNumber.text;
    [user setObject:user.username forKey:@"phone"];
//    NSError *error = nil;
//    [user signUp:&error];
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"注册成功");
            [SVProgressHUD showSuccessWithStatus:@"注册成功，请在5分钟内完成验证"];
            self.registerView.securityCode.hidden = NO;
            self.registerView.checkButton.hidden = NO;
        }else{
            NSLog(@"注册失败:%@",error);
        }
    }];
}

- (void)resetPassword{
    [AVUser resetPasswordWithSmsCode:self.forgetPWView.securityCode.text newPassword:self.forgetPWView.createPW.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"重置密码成功");
        }else{
            NSLog(@"重置密码失败：%@",error);
        }
    }];
}

- (void)activeButtonAction{
    __weak typeof(self) weakSelf = self;
    self.registerView.buttonActionBlock =  ^(NSDictionary *info, NSInteger type){
        switch (type) {
            case 0:
                //验证验证码
            {
                [AVUser verifyMobilePhone:weakSelf.registerView.securityCode.text withBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"验证短信验证码成功");
                        [SVProgressHUD showSuccessWithStatus:@"验证短信验证码成功"];
                        WelcomeType = SMWelcomePageTypeLogin;
                        [weakSelf createLoginView];
                    }else{
                        NSLog(@"验证短信验证码失败");
                    }
                }];
            }
                break;
                
            default:
                break;
        }
    };
    self.loginView.buttonActionBlock =  ^(NSDictionary *info, NSInteger type){
        switch (type) {
            case 0:
                //忘记密码
                WelcomeType = SMWelcomePageTypeForgetPW;
                //[weakSelf getSecurityCode];
                [weakSelf createForgetPWView];
                break;
                
            default:
                break;
        }
    };

    self.forgetPWView.buttonActionBlock = ^(NSDictionary *info, NSInteger type){
        switch (type) {
            case 0:
                [weakSelf getSecurityCode];
                break;
                
            default:
                break;
        }
    };
}

- (void)getSecurityCode{
    [AVUser requestPasswordResetWithPhoneNumber:self.forgetPWView.phoneNumber.text block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"获取短信验证码成功");
        } else {
            NSLog(@"获取短信验证码失败:%@",error);
        }
    }];
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
    [self.registerView removeFromSuperview];
    [self.forgetPWView removeFromSuperview];
    [self.view addSubview:self.loginView];
}

- (void)createRegisterView{
    self.registerView.securityCode.hidden = YES;
    self.registerView.checkButton.hidden = YES;
    [self.loginView removeFromSuperview];
    [self.forgetPWView removeFromSuperview];
    [self.view addSubview:self.registerView];
}

- (void)createForgetPWView{
    [self.registerView removeFromSuperview];
    [self.loginView removeFromSuperview];
    [self.view addSubview:self.forgetPWView];
}

//点击空白处收起键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent             *)event{
    [self.loginView.phoneNumber resignFirstResponder];
    [self.loginView.PassWord resignFirstResponder];
    [self.registerView.phoneNumber resignFirstResponder];
    [self.registerView.PWTextField resignFirstResponder];
    [self.registerView.ConfirmPW resignFirstResponder];
    [self.registerView.securityCode resignFirstResponder];
    [self.forgetPWView.phoneNumber resignFirstResponder];
    [self.forgetPWView.createPW resignFirstResponder];
    [self.forgetPWView.confirmPW resignFirstResponder];
    [self.forgetPWView.securityCode resignFirstResponder];

}

- (SMLoginView *)loginView{
    if (!_loginView) {
        _loginView = [SMLoginView loadNibName:@"SMLoginView"];
        _loginView.frame = CGRectMake(0, 120, self.view.frame.size.width, 250);
    }
    return _loginView;
}

- (SMRegisterView *)registerView{
    if (!_registerView) {
        _registerView = [SMRegisterView loadNibName:@"SMRegisterView"];
        _registerView.frame = CGRectMake(0, 120, self.view.frame.size.width, 350);;
    }
    return _registerView;
}

- (SMForgetPWView *)forgetPWView{
    if (!_forgetPWView) {
        _forgetPWView = [SMForgetPWView loadNibName:@"SMForgetPWView"];
        _forgetPWView.frame = CGRectMake(0, 120, self.view.frame.size.width, 250);;
    }
    return _forgetPWView;
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
