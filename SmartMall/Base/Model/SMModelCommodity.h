//
//  SMModelCommodity.h
//  SmartMall
//
//  Created by 庞启友 on 15/10/19.
//  Copyright © 2015年 BIMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMModelCommodity : NSObject

@property (nonatomic, strong) NSString *cmdyName;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *disPrice;
@property (nonatomic, strong) NSString *cmdyEncode;//商品编号
@property (nonatomic, strong) NSString *stock;//
@property (nonatomic, strong) NSString *url;//图片下载地址
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *pdtionDate;
@property (nonatomic, strong) NSString *barcode;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) NSString *isDiscount;
@property (nonatomic, strong) NSArray *urls;


@end
