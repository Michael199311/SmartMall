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
    SMWelcomePageTypeForgetPW,
    SMWelcomePageTypeVerify
}SMWelcomePageType;

@interface SMRegisterAndLoginVC ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    SMWelcomePageType WelcomeType;
    UITextField *Phone;
    UITextField *NewPW;
    UITextField *ConfirmPW;
    UIView *statusView;
    __weak IBOutlet UIButton *registerButton;
    __weak IBOutlet UIButton *loginButton;
    
    __weak IBOutlet UIButton *finishButton;
    NSTimer *timer;
    int count;
    
    
}

@end

@implementation SMRegisterAndLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    count = 0;
//    self.registerView.securityCode.hidden = YES;
//    self.registerView.checkButton.hidden = YES;
    WelcomeType = SMWelcomePageTypeLogin;
    statusView = [[UIView alloc] init];
    statusView.frame = CGRectMake(self.view.width/2 , 71, self.view.width/2 - 8, 1);
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
    NSLog(@"%f,%f,%f,%f",sender.x,sender.y,sender.height,sender.width);
    [self createView];
}

- (IBAction)turnLoginView:(UIButton *)sender {
    statusView.frame = CGRectMake(sender.x, sender.y + sender.height +1, sender.width, 1);
    NSLog(@"%f,%f,%f,%f",sender.x,sender.y,sender.height,sender.width);

    WelcomeType = SMWelcomePageTypeLogin;
    [self createView];
}

- (IBAction)finish:(UIButton *)sender {
    [timer invalidate];
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
        case SMWelcomePageTypeVerify:
            //注册页面验证手机号
            [self verifyPhoneNumber];
            break;
            
        default:
            break;
    }
}

- (void)login{
    if (![NSString isNotEmptyString:self.loginView.phoneNumber.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入登录账号"];
        return;
    }else if (![NSString isNotEmptyString:self.loginView.PassWord.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入登录密码"];
        return;
    }
    NSString *username = self.loginView.phoneNumber.text;
    NSString *password = self.loginView.PassWord.text;
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeGradient];
    finishButton.enabled = NO;
    [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
        finishButton.enabled = YES;
        if (user != nil) {
            NSLog(@"登录成功");
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            //保存用户信息
            [AVUser changeCurrentUser:user save:YES];
            
            SMModelUser *SMUser = [[SMModelUser alloc] init];
            SMUser.name = username;
            SMUser.password = password;
            SMUser.phoneNumber = username;
            [SMModelUser saveUserToLocalWithUser:SMUser];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //进入首页
                //SMHomePageViewController *homePageVC = (SMHomePageViewController  *)[UIStoryboard instantiateViewControllerWithIdentifier:@"HomePageVC" andStroyBoardNameString:@"Main"];
                SMHomePageViewController *homeController = (SMHomePageViewController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"HomePageVC" andStroyBoardNameString:@"Main"];
                [self presentViewController:homeController animated:YES completion:nil];
            });
            
        }else{
            NSLog(@"登录失败");
            [SVProgressHUD showErrorWithStatus:@"登录失败！请检查您的用户名和密码是否输入正确"];
        }
        
    }];
}

- (void)registerNewUser{
    if (![NSString isNotEmptyString:self.registerView.phoneNumber.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入注册手机号"];
        return;
    }else if (![NSString isNotEmptyString:self.registerView.PWTextField.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }else if (![NSString isNotEmptyString:self.registerView.ConfirmPW.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
        return;
    }
    if (![self.registerView.PWTextField.text isEqualToString:self.registerView.ConfirmPW.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
        return;
    }
    AVUser *user = [AVUser user];
    user.username = self.registerView.phoneNumber.text;
    user.password = self.registerView.PWTextField.text;
    user.mobilePhoneNumber = self.registerView.phoneNumber.text;
    [user setObject:user.username forKey:@"phone"];
    [SVProgressHUD showWithStatus:@"注册中..." maskType:SVProgressHUDMaskTypeGradient];
    finishButton.enabled = NO;
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        finishButton.enabled = YES;
        if (succeeded) {
            NSLog(@"注册成功");
            [SVProgressHUD showSuccessWithStatus:@"注册成功，请在5分钟内完成验证"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[self showCodeInputTextField];
                self.registerView.securityCode.hidden = NO;
                self.registerView.checkButton.hidden = NO;
            });
            WelcomeType = SMWelcomePageTypeVerify;
            [self startTimer];
            [finishButton setTitle:@"验证" forState:UIControlStateNormal];
        }else{
            NSLog(@"注册失败:%@",error);
            [SVProgressHUD showErrorWithStatus:@"注册失败"];
        }
    }];
}

- (void)resetPassword{
    if (![NSString isNotEmptyString:self.forgetPWView.phoneNumber.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入注册手机号"];
        return;
    }else if (![NSString isNotEmptyString:self.forgetPWView.createPW.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }else if (![NSString isNotEmptyString:self.forgetPWView.confirmPW.text]){
        [SVProgressHUD showErrorWithStatus:@"请输入确认密码"];
        return;
    }else if (![NSString isNotEmptyString:self.forgetPWView.securityCode.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (![self.forgetPWView.createPW.text isEqualToString:self.forgetPWView.confirmPW.text]) {
        [SVProgressHUD showErrorWithStatus:@"两次输入密码不一致"];
    }
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD showWithStatus:@"重置密码中..." maskType:SVProgressHUDMaskTypeGradient];
    finishButton.enabled = NO;
    [AVUser resetPasswordWithSmsCode:self.forgetPWView.securityCode.text newPassword:self.forgetPWView.createPW.text block:^(BOOL succeeded, NSError *error) {
        finishButton.enabled = YES;
        if (succeeded) {
            NSLog(@"重置密码成功");
            [SVProgressHUD showSuccessWithStatus:@"重置密码成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WelcomeType = SMWelcomePageTypeLogin;
                [weakSelf createLoginView];
            });
        }else{
            [SVProgressHUD showErrorWithStatus:@"重置密码失败"];
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
                [weakSelf getSecurityCode];
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
    if (WelcomeType == SMWelcomePageTypeForgetPW) {
        [AVUser requestPasswordResetWithPhoneNumber:self.forgetPWView.phoneNumber.text block:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"获取短信验证码成功");
                [self startTimer];
            } else {
                NSLog(@"获取短信验证码失败:%@",error);
                [SVProgressHUD showErrorWithStatus:@"获取短信验证码失败"];
            }
        }];
    }else{
        WelcomeType = SMWelcomePageTypeVerify;
        [finishButton setTitle:@"验证" forState:UIControlStateNormal];
        [AVUser requestMobilePhoneVerify:self.registerView.phoneNumber.text withBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"重新获取验证码成功");
                [self startTimer];
            }else{
                NSLog(@"获取验证码失败:%@",error);
                [SVProgressHUD showErrorWithStatus:@"获取验证码失败"];
            }
        }];
    }
}

- (void)showCodeInputTextField{
    UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"注册成功" message:@"请输入验证码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"重新获取", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    UITextField *titleTextField = [alert textFieldAtIndex:0];
    titleTextField.delegate = self;
    titleTextField.keyboardType = UIKeyboardTypeNumberPad;
    [alert show];
}

- (void)verifyPhoneNumber{
    [SVProgressHUD showWithStatus:@"验证短信验证码中，请稍候..." maskType:SVProgressHUDMaskTypeGradient];
    [AVUser verifyMobilePhone:self.registerView.securityCode.text withBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"验证短信验证码成功");
            [SVProgressHUD showSuccessWithStatus:@"验证短信验证码成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                WelcomeType = SMWelcomePageTypeLogin;
                [self createLoginView];
            });
            
        }else{
            NSLog(@"验证短信验证码失败");
            [SVProgressHUD showErrorWithStatus:@"验证短信验证码失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showCodeInputTextField];
            });
        }
    }];
}

- (void)startTimer{
    if (WelcomeType == SMWelcomePageTypeVerify || WelcomeType == SMWelcomePageTypeRegister) {
        self.registerView.checkButton.enabled = NO;
        [self.registerView.checkButton setTitle:@"60" forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeButtonTitle) userInfo:nil repeats:YES];
    }else if (WelcomeType == SMWelcomePageTypeForgetPW){
        self.forgetPWView.getSecurityCodeButton.enabled = NO;
        [self.forgetPWView.getSecurityCodeButton setTitle:@"60" forState:UIControlStateNormal];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeButtonTitle) userInfo:nil repeats:YES];
    }
}

- (void)changeButtonTitle{
    count ++;
    NSString *title = [[NSString alloc] init];
    if (count == 60) {
        [timer invalidate];
        count = 0;
        title = @"重新获取";
        self.registerView.checkButton.enabled = YES;
        self.forgetPWView.getSecurityCodeButton.enabled = YES;
    }else{
    title = [NSString stringWithFormat:@"%d",60-count];
    }
    if (WelcomeType == SMWelcomePageTypeVerify || WelcomeType == SMWelcomePageTypeRegister) {
        [self.registerView.checkButton setTitle:title forState:UIControlStateNormal];
    }else if (WelcomeType == SMWelcomePageTypeForgetPW){
        [self.forgetPWView.getSecurityCodeButton setTitle:title forState:UIControlStateNormal];
    }
    
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
    [finishButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.registerView removeFromSuperview];
    [self.forgetPWView removeFromSuperview];
    [self.view addSubview:self.loginView];
}

- (void)createRegisterView{
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.loginView removeFromSuperview];
    [self.forgetPWView removeFromSuperview];
    [self.view addSubview:self.registerView];
}

- (void)createForgetPWView{
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSLog(@"输入的验证码:%@",textField.text);
        if (textField.text.length == 6) {
            [SVProgressHUD showWithStatus:@"验证短信验证码中，请稍候..." maskType:SVProgressHUDMaskTypeGradient];
            [AVUser verifyMobilePhone:textField.text withBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"验证短信验证码成功");
                    [SVProgressHUD showSuccessWithStatus:@"验证短信验证码成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        WelcomeType = SMWelcomePageTypeLogin;
                        [self createLoginView];
                    });
                    
                }else{
                    NSLog(@"验证短信验证码失败");
                    [SVProgressHUD showErrorWithStatus:@"验证短信验证码失败"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showCodeInputTextField];
                    });
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:@"请输入正确的6位PIN码！"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showCodeInputTextField];
            });
        }
    }else if (buttonIndex == 1){
        [self verifyPhoneNumber];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //length == 0表示输入，否则表示删除
    NSString *text = textField.text;//编辑前的文本
    CGFloat length = 0;//编辑后文本长度
    if (range.length == 0) {
        
        //计算输入后，文本长度是否大于6
        length = text.length + 1;
    }else{
        length = text.length - 1;
    }
    if (length > 6) {
        return NO;
    }
    return YES;
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
        _registerView.frame = CGRectMake(0, 120, self.view.frame.size.width, 321);;
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
