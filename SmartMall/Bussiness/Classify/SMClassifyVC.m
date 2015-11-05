//
//  SMClassifyVC.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/19.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMClassifyVC.h"
#import "MultilevelMenu.h"
#import "NSString+Additions.h"
#import "SMClassifyDetailVC.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SMClassifyVC ()
    @property (nonatomic, strong) NSMutableArray *level1;
    @property (nonatomic, strong) NSMutableArray *level2;
    @property (nonatomic, strong) NSMutableArray *level3;


@end

@implementation SMClassifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray * lis=[NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *dic1 = [self turnJsonToDic:@"level1"];
    self.level1 = dic1[@"0"];
    NSDictionary *dic2 = [self turnJsonToDic:@"level2"];
    for (int i = 0; i < 14; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        if ([NSString isNotEmptyString:str]) {
            NSArray *arr = dic2[str];
            [self.level2 addObject:arr];
        }
    }
    NSDictionary *dic3 = [self turnJsonToDic:@"level3"];
    for (int i = 0; i < 14; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",i];
        NSDictionary *dic = dic3[str];
        NSMutableArray *arr = [[NSMutableArray alloc] init];

        for (int j=0; j < 8; j++) {
            NSString *str2 = [NSString stringWithFormat:@"%d",j];
            
            if ([NSString isNotEmptyString:str2]) {
                NSArray *arr2 = dic[str2];
                if (arr2 && arr2.count != 0) {
                    [arr addObject:arr2];
                }
            }
        }
        if (arr && arr.count != 0) {
            [self.level3 addObject:arr];
        }
        
    }
    

    /**
     *  构建需要数据 2层或者3层数据 (ps 2层也当作3层来处理)
     */
    NSInteger countMax=self.level1.count;
    for (int i=0; i<countMax; i++) {
        
        rightMeun * meun=[[rightMeun alloc] init];
        meun.meunName=self.level1[i];
        NSMutableArray * sub=[NSMutableArray arrayWithCapacity:0];
        NSArray *arr2 = self.level2[i];
        for ( int j=0; j <arr2.count; j++) {
            
            rightMeun * meun1=[[rightMeun alloc] init];
            meun1.meunName=self.level2[i][j];
            
            [sub addObject:meun1];
            
            //meun.meunNumber=2;
            
            NSMutableArray *zList=[NSMutableArray arrayWithCapacity:0];
            NSArray *arr3 = self.level3[i][j];
                for ( int z=0; z <arr3.count; z++) {
                    
                    rightMeun * meun2=[[rightMeun alloc] init];
                    meun2.meunName=self.level3[i][j][z];
                    meun2.meunNumber = j;
                    [zList addObject:meun2];
                }
            meun1.nextArray=zList;
        }
        meun.nextArray=sub;
        [lis addObject:meun];
    }
    
    /**
     *  适配 ios 7 和ios 8 的 坐标系问题
     */
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    /**
     默认是 选中第一行
     
     :returns: <#return value description#>
     */
    __block NSString *A  = @"A";
    __block NSString *B = @"00";
    __block NSString *C = @"00";
    MultilevelMenu * view=[[MultilevelMenu alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) WithData:lis withSelectIndex:^(NSInteger left, NSInteger right,rightMeun* info) {
        SMClassifyDetailVC *classifyDetailVC = (SMClassifyDetailVC *)[UIStoryboard instantiateViewControllerWithIdentifier:@"ClassifyDetailVC" andStroyBoardNameString:@"Main"];
        
        if (left == 0) {
            A = @"A";
        }else if (left == 1) {
            A = @"B";
        }else if (left == 2) {
            A = @"C";
        }
        else if (left == 3) {
            A = @"D";
        }
        else if (left == 4) {
            A = @"E";
        }
        else if (left == 5) {
            A = @"F";
        }
        else if (left == 6) {
            A = @"G";
        }
        else if (left == 7) {
            A = @"H";
        }
        else if (left == 8) {
            A = @"I";
        }
        else if (left == 9) {
            A = @"J";
        }
        else if (left == 10) {
            A = @"K";
        }
        else if (left == 11) {
            A = @"L";
        }
        else if (left == 12) {
            A = @"M";
        }
        else if (left == 13) {
            A = @"N";
        }
        
        if (info.meunNumber/10 == 0) {
            B = [NSString stringWithFormat:@"0%ld",(long)info.meunNumber];
        }else{
            B = [NSString stringWithFormat:@"%ld",(long)info.meunNumber];
        }
        
        if (right/10 == 0) {
            C = [NSString stringWithFormat:@"0%ld",(long)right];
        }else{
            C = [NSString stringWithFormat:@"%ld",(long)right];
        }

        
        classifyDetailVC.classId = [NSString stringWithFormat:@"%@%@%@",A,B,C];
        //classifyDetailVC.classId = @"A0001";
        NSLog(@"要进入的分类栏的分类id：%@",classifyDetailVC.classId);
        classifyDetailVC.buttonTitles = self.level3[left][info.meunNumber];
        classifyDetailVC.mcEncode = @"SH100001";
        //[self presentViewController:classifyDetailVC animated:YES completion:nil];
        [self.navigationController pushViewController:classifyDetailVC animated:YES];
                        
        NSLog(@"左边：%ld,右边：%ld",(long)left,(long)right);
        NSLog(@"点击的 菜单%@",info.meunName);
        
    }];
    
    
    view.needToScorllerIndex=0;
    
    view.isRecordLastScroll=YES;
    [self.view addSubview:view];

    // Do any additional setup after loading the view.
}

- (id)turnJsonToDic:(NSString *)json{
    NSString *path = [[NSBundle mainBundle] pathForResource:json ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:nil];
    
    return  [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
}

- (NSMutableArray *)level1{
    if (!_level1) {
        _level1 = [[NSMutableArray alloc] init];
    }
    return _level1;
}

-(NSMutableArray *)level2{
    if (!_level2) {
        _level2 = [[NSMutableArray alloc] init];
    }
    return _level2;
}

- (NSMutableArray *)level3{
    if (!_level3) {
        _level3 = [[NSMutableArray alloc] init];
    }
    return _level3;
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
