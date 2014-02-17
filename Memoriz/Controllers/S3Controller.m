//
//  S3Controller.m
//  Memoriz
//
//  Created by Zenan on 26/3/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "S3Controller.h"
#import "NetworkConfig.h"
#import <AWSiOSSDK/AmazonEndpoints.h>

@implementation S3Controller

-(id)init
{
    if (self = [super init]) {
        // Initial the S3 Client.
        self.s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY_ID withSecretKey:SECRET_KEY];
        self.s3.endpoint = [AmazonEndpoints s3Endpoint:AP_SOUTHEAST_1];
        
    }
    return self;
}

-(NSString*)imageBucket
{
    return [[NSString stringWithFormat:@"memoriz-app-photo-%@%@", ACCESS_KEY_ID, PICTURE_BUCKET] lowercaseString];
}

-(void)uploadImageToS3Bucket:(NSData *)imageData Completion:(void(^)(BOOL success, NSString *photoPath))callback
{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // Upload image data.  Remember to set the content type.
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"y-MM-dd"];
        NSString *photoPath = [formatter stringFromDate:[NSDate date]];
        CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
        
        photoPath = [photoPath stringByAppendingPathComponent:(__bridge NSString*)newUniqueIDString];
        photoPath = [photoPath stringByAppendingPathExtension:@"jpg"];
        
        S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:photoPath
                                                                  inBucket:[self imageBucket]];
        por.contentType = EXTENSION_TYPE_JPEG;
        por.data        = imageData;
        
        // Put the image data into the specified s3 bucket and object.
        S3PutObjectResponse *putObjectResponse = [self.s3 putObject:por];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(putObjectResponse.error != nil)
            {
                // TODO
                NSLog(@"Error: %@", putObjectResponse.error);
                callback(NO, nil);
            }
            else
            {
                // TODO
                NSLog(@"Success");
                callback(YES, photoPath);
            }
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    });
}


-(void)getImageURLByFilePath:(NSString*)filePath Completion:(void(^)(NSURL *url, NSError *error))callback
{
    
    NSLog(@"%@", filePath);
    // Set the content type so that the browser will treat the URL as an image.
    
    if ([[EGOCache globalCache] hasCacheForKey:filePath]) {
        return callback((NSURL*)[[EGOCache globalCache] objectForKey:filePath], nil);
    }
    
    S3ResponseHeaderOverrides *override = [[S3ResponseHeaderOverrides alloc] init];
    override.contentType = @"image/jpeg";
    
    // Request a pre-signed URL to picture that has been uplaoded.
    S3GetPreSignedURLRequest *gpsur = [[S3GetPreSignedURLRequest alloc] init];
    
    gpsur.key                     = filePath;
    gpsur.bucket                  = [self imageBucket];
    // Added an hour's worth of seconds to the current time.
    gpsur.expires                 = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) CACHE_IMAGE_TIMEOUT];
    gpsur.responseHeaderOverrides = override;
    
    NSError *error;
    
    // Get the URL
    NSURL *url = [self.s3 getPreSignedURL:gpsur error:&error];
    [[EGOCache globalCache] setObject:url forKey:filePath];
    callback(url, error);
}

@end
