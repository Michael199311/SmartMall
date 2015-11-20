//
//  SMButtomNavigater.m
//  SmartMall
//
//  Created by Codger on 15/11/18.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMButtomNavigater.h"
#import "SMMerchantDetailVC.h"
#import "SMClassifyVC.h"
#import "SMShoppingCartVC.h"

@interface SMButtomNavigater ()
@property (weak, nonatomic) IBOutlet UIButton *homePageBotton;
@property (weak, nonatomic) IBOutlet UIButton *classifyButton;
@property (weak, nonatomic) IBOutlet UIButton *shoppingCartButton;
@property (weak, nonatomic) IBOutlet UIButton *aboutMeButton;

@end

static SMButtomNavigater *navigater = nil;

@implementation SMButtomNavigater

+ (SMButtomNavigater *)sharedButtomNavigater{
    if (!navigater) {
        navigater = [SMButtomNavigater loadNibName:@"SMButtomNavigater"];
    }
    return navigater;
}
- (IBAction)homePage:(UIButton *)sender {
    //[sender setImage:[UIImage imageNamed:@"homePageChoose"] forState:UIControlStateNormal];
    [self.classifyButton setImage:[UIImage imageNamed:@"tabBar2"] forState:UIControlStateNormal];
    [self.shoppingCartButton setImage:[UIImage imageNamed:@"tabBar3"] forState:UIControlStateNormal];
    [self.aboutMeButton setImage:[UIImage imageNamed:@"tabBar4"] forState:UIControlStateNormal];
    UINavigationController *vc = (UINavigationController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"homePageNav" andStroyBoardNameString:@"Main"];
    [self.controller presentViewController:vc animated:YES completion:nil];
}

- (IBAction)classify:(UIButton *)sender {
    //[sender setImage:[UIImage imageNamed:@"classifyChoose"] forState:UIControlStateNormal];
    [self.homePageBotton setImage:[UIImage imageNamed:@"tabBar1"] forState:UIControlStateNormal];
    [self.shoppingCartButton setImage:[UIImage imageNamed:@"tabBar3"] forState:UIControlStateNormal];
    [self.aboutMeButton setImage:[UIImage imageNamed:@"tabBar4"] forState:UIControlStateNormal];
    UINavigationController *vc = (UINavigationController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"classifyNav" andStroyBoardNameString:@"Main"];
    [self.controller presentViewController:vc animated:YES completion:nil];
}

- (IBAction)shoppingCart:(UIButton *)sender {
    //[sender setImage:[UIImage imageNamed:@"shoppingCartChoose"] forState:UIControlStateNormal];
    [self.homePageBotton setImage:[UIImage imageNamed:@"tabBar1"] forState:UIControlStateNormal];
    [self.classifyButton setImage:[UIImage imageNamed:@"tabBar2"] forState:UIControlStateNormal];
    [self.aboutMeButton setImage:[UIImage imageNamed:@"tabBar4"] forState:UIControlStateNormal];
    UINavigationController *vc = (UINavigationController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"shoppingCartNav" andStroyBoardNameString:@"Main"];
    [self.controller presentViewController:vc animated:YES completion:nil];
}


- (IBAction)aboutMe:(UIButton *)sender {
    [self.shoppingCartButton setImage:[UIImage imageNamed:@"tabBar3"] forState:UIControlStateNormal];
    [self.homePageBotton setImage:[UIImage imageNamed:@"tabBar1"] forState:UIControlStateNormal];
    [self.classifyButton setImage:[UIImage imageNamed:@"tabBar2"] forState:UIControlStateNormal];
    [self.aboutMeButton setImage:[UIImage imageNamed:@"tabBar4"] forState:UIControlStateNormal];
    
    UINavigationController *vc = (UINavigationController *)[UIStoryboard instantiateViewControllerWithIdentifier:@"homePageNav" andStroyBoardNameString:@"Main"];
    //[self.controller presentViewController:vc animated:YES completion:nil];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
