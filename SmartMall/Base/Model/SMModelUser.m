//
//  SMModelUser.m
//  SmartMall
//
//  Created by 庞启友 on 15/10/26.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "SMModelUser.h"
#import "CRDataSotreManage.h"
#import "MJExtension.h"

static SMModelUser *currentUser;

@implementation SMModelUser

- (NSMutableArray *)commoditysArray{
    if (!_commoditysArray) {
        _commoditysArray = [[NSMutableArray alloc] init];
    }
    return _commoditysArray;
}

- (NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [[NSMutableArray alloc] init];
    }
    return _addressArray;
}

- (NSDictionary *)defaultConsigneeInfo{
    if (!_defaultConsigneeInfo) {
        _defaultConsigneeInfo = @{
                                  @"name":@"李一凡",
                                  @"phone":@"13918899076",
                                  @"address":@"上海市徐汇区康健街道桂林路567弄15-201"
                                  };
    }
    return _defaultConsigneeInfo;
}

+ (SMModelUser *)currentUser{
//    NSDictionary *currentUser = [CRDataSotreManage objectForKey:NSStringFromClass([SMModelUser class])];
//    return currentUser?[SMModelUser objectWithKeyValues:currentUser]:nil;
    if (!currentUser) {
        currentUser = [[SMModelUser alloc] init];
    }
    return currentUser;
}
+ (void)saveUserToLocalWithUser:(SMModelUser *)user{
        [CRDataSotreManage setObject:[user keyValues] forKey:NSStringFromClass([SMModelUser class])];
}

@end
