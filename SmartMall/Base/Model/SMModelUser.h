//
//  SMModelUser.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/26.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import "AVUser.h"

@interface SMModelUser : NSObject

@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSMutableArray *commoditysArray;
@property (nonatomic, strong) NSDictionary *defaultConsigneeInfo;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSArray *merchants;
+ (SMModelUser *)currentUser;
+ (void)saveUserToLocalWithUser:(SMModelUser *)user;
@end
