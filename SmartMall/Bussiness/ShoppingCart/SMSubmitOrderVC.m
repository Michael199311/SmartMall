//
//  SMSubmitOrderVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/21.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMSubmitOrderVC.h"

@interface SMSubmitOrderVC ()
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


@end

@implementation SMSubmitOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)submitOrder:(id)sender {
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
