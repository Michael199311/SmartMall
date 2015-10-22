//
//  SMRegisterAndLoginVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/13.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMRegisterAndLoginVC.h"
#import "SMLoginView.h"
#import "SMRegisterView.h"
#import "SMForgetPWView.h"
#import "UIView+CRAdditions.h"
#import <AVUser.h>
#import "SMHomePageViewController.h"
#import "UIStoryboard+CRInstantiate.h"
#import "SMMerchantDetailVC.h"
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
    __weak IBOutlet UIView *statusView;
    
    
}
@property (nonatomic, strong) SMLoginView *loginView;
@property (nonatomic, strong) SMRegisterView *registerView;
@property (nonatomic, strong) SMForgetPWView *forgetPWView;
@end

@implementation SMRegisterAndLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    [self activeButtonAction];
    WelcomeType = SMWelcomePageTypeRegister;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)turnRegisterView:(UIButton *)sender {
    WelcomeType = SMWelcomePageTypeRegister;
    [self createView];
}
- (IBAction)turnLoginView:(id)sender {
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
            //进入首页
            SMHomePageViewController *homePageVC = (SMHomePageViewController  *)[UIStoryboard instantiateViewControllerWithIdentifier:@"HomePageVC" andStroyBoardNameString:@"Main"];
            [self presentViewController:homePageVC animated:YES completion:nil];
            
            
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
            [SVProgressHUD showSuccessWithStatus:@"这侧成功，请在5分钟内完成验证"];
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
                [weakSelf getSecurityCode];
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
    [AVUser requestPasswordResetWithPhoneNumber:@"18521508147" block:^(BOOL succeeded, NSError *error) {
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
    [self.loginView removeFromSuperview];
    [self.forgetPWView removeFromSuperview];
    [self.view addSubview:self.registerView];
}

- (void)createForgetPWView{
    [self.registerView removeFromSuperview];
    [self.loginView removeFromSuperview];
    [self.view addSubview:self.forgetPWView];
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
