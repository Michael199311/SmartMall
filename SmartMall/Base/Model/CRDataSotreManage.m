//
//  CRDataSotreManage.m
//  CarRental
//
//  Created by 王健功 on 15/7/8.
//  Copyright (c) 2015年 JieXing. All rights reserved.
//

#import "CRDataSotreManage.h"

@implementation CRDataSotreManage

+ (NSString *)getFilePath:(NSString *)fileName
{
	NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSLog(@"Documents文件路径:%@",documentsDirectoryPath);
	NSString *filePath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
	return filePath;
}

+ (NSString *)getAvatorNameWithUrl:(NSString *)imageUrl
{
	NSArray *substrings = [imageUrl componentsSeparatedByString:@"/"];
	NSString *avatorName = [substrings lastObject];
	return avatorName;
}

+ (void)writeImageTofile:(UIImage*)image
				filePath:(NSString*)filePath
	  compressionQuality:(CGFloat)compressionQuality
{
	if (image == nil)
		return;
	@try
	{
		NSString *trueFilePath = [CRDataSotreManage getFilePath:[self getAvatorNameWithUrl:filePath]];
		NSData *imageData = nil;
		NSString *ext = [filePath pathExtension];//获取扩展名()
		if ([ext isEqualToString:@"png"])
			imageData = UIImagePNGRepresentation(image);
		else
		{
			imageData = UIImageJPEGRepresentation(image, compressionQuality);
		}
		if ((imageData == nil) || ([imageData length] <= 0))
		{
			return;
		}
		NSLog(@"图片本地地址:%@",trueFilePath);
		[imageData writeToFile:trueFilePath atomically:YES];
		NSLog(@"文件存储结果:%d",[imageData writeToFile:trueFilePath atomically:YES]);
	}
	@catch (NSException *e)
	{
		NSLog(@"创建分享的临时图片错误：%@",e);
	}
}

+ (void)removeFileFromFilePath:(NSString *)filePath
{
	if (filePath) {
		NSString *trueFilePath = [CRDataSotreManage getFilePath:[self getAvatorNameWithUrl:filePath]];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if ([fileManager fileExistsAtPath:trueFilePath]) {
			NSError *error;
			BOOL success = [fileManager removeItemAtPath:trueFilePath error:&error];
			NSLog(@"删除文件:%d",success);
			if (error) {
				NSLog(@"删除文件失败------:%@",error.description);
				NSParameterAssert(error);
			}
		}
	}
}

+ (UIImage *)loadImageFromFilePath:(NSString *)filePath
{
	NSString *trueFilePath = [CRDataSotreManage getFilePath:[self getAvatorNameWithUrl:filePath]];
	NSLog(@"图片本地地址:%@",trueFilePath);
	return [UIImage imageWithContentsOfFile:trueFilePath];
}

+ (void)setObject:(id)obj forKey:(NSString *)key {
	if ([obj respondsToSelector:@selector(encodeWithCoder:)] == NO) {
		NSLog(@"Error save object to NSUserDefaults. Object must respond to encodeWithCoder: message");
		return;
	}
    //这里obj是字典的话，它的value们会分别执行encodeWithCoder:方法，所以要保证obj的元素是否能执行encodeWithCoder：方法，如果不能执行，则到这里程序会报错
	NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:obj];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:encodedObject forKey:key];
	[defaults synchronize];
}

+ (id)objectForKey:(NSString *)key {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSData *encodedObject = [defaults objectForKey:key];
	id obj = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
	return obj;
}

+ (void)clearObjectForUserDefaultForKey:(NSString *)key
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults removeObjectForKey:key];
	[defaults synchronize];
}

@end
