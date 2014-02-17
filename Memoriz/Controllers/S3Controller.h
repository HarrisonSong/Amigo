//
//  S3Controller.h
//  Memoriz
//
//  Created by Zenan on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSiOSSDK/S3/AmazonS3Client.h>

@interface S3Controller : NSObject

@property (nonatomic, strong) AmazonS3Client *s3;

/*!
 upload image to S3 bucket with Grand Central Dispatch
 @param: image data to be uploaded
 @param: callback function with success indicator and photoPath
 */

-(void)uploadImageToS3Bucket:(NSData *)imageData Completion:(void(^)(BOOL success, NSString *photoPath))callback;


/*!
 get upload image url by file path
 @param: the path of the image file on s3.
 @param: callback function with the signed url and error
 */
-(void)getImageURLByFilePath:(NSString*)filePath Completion:(void(^)(NSURL *url, NSError *error))callback;


@end
