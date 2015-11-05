//
//  CRDataSotreManage.h
//  CarRental
//
//  Created by 王健功 on 15/7/8.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CRDataSotreManage : NSObject
#pragma mark - local file
/**
 *  存储图片到本地文件目录中
 *
 *  @param filePath           存储路径
 *  @param compressionQuality jpg格式压缩比率
 *
 *  @return 返回正确的目录地址
 */
+ (void)writeImageTofile:(UIImage*)image
				filePath:(NSString*)filePath
	  compressionQuality:(CGFloat)compressionQuality;
/**
 *  删除指定目录的文件
 *
 */
+ (void)removeFileFromFilePath:(NSString *)filePath;
/**
 *  根据目录查找记录的图片
 */
+ (UIImage *)loadImageFromFilePath:(NSString *)filePath;

#pragma mark - SQL

#pragma mark - store to userDefault
/**
 *  通过归档的方式，将数据存储到NSUserDefault中
 *
 *  @param obj 需要存储的对象
 *  @param key key
 */
+ (void)setObject:(id)obj forKey:(NSString *)key;
/**
 *  通过key获取存储在NSUserDefault中的数据
 *
 *  @param key key
 *
 *  @return 返回查询的数据
 */
+ (id)objectForKey:(NSString *)key;
/**
 *  通过key清除本地记录
 *
 */
+ (void)clearObjectForUserDefaultForKey:(NSString *)key;

@end
