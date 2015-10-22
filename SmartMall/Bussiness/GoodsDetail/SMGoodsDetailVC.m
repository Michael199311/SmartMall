//
//  SMGoodsDetailVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/19.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMGoodsDetailVC.h"
#import "SMModelCommodity.h"

@interface SMGoodsDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *detail;
@property (strong, nonatomic) SMModelCommodity *commodity;
@end

@implementation SMGoodsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *param = @{
//                            @"mcEncode":self.mcEncode,
//                            @"cmdyEncode":self.cmdyEncode
                            @"mcEncode":@"SH100001",
                            @"cmdyEncode":@"D0103002"
                            };
    [AVCloud callFunctionInBackground:@"GetCmdyInfo" withParameters:param block:^(NSDictionary *dic, NSError *error) {
        if (error) {
            NSLog(@"获取商品详情失败");
        }else{
            self.commodity = [SMModelCommodity objectWithKeyValues:dic];
            [self updateView];
        }
    }];
}

- (void)updateView{
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.commodity.urls.firstObject]];
    if (data) {
        self.image.image = [UIImage imageWithData:data];
    }
    self.price.text = [self.commodity.price stringValue];
    self.name.text = self.commodity.cmdyName;
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
