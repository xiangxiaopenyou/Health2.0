//
//  RTUploadImageNetWork.m
//  RTHealth
//
//  Created by cheng on 14/11/21.
//  Copyright (c) 2014年 realtech. All rights reserved.
//

#import "RTUploadImageNetWork.h"
#import "QiniuSDK.h"

@implementation RTUploadImageNetWork

+ (void)postMulti:(NSString*)url imageparams:(UIImage*)imageparams success:(void(^)(id response))success failure:(void(^)(NSError *error))failure Progress:(void(^)(NSString *key,float percent))progress Cancel:(BOOL(^)(void))cancel{
    
    
    NSString *filename = [NSString stringWithFormat:@"%@",[CustomDate getFileNameString:[NSDate date]]];
    
//    QNUploadOption *opt = [[QNUploadOption alloc]initWithMime:@"image/png" progressHandler:^(NSString *key, float percent){
//        if (progress) {
//            progress(key,percent);
//        }
//    } params:dictionary checkCrc:NO cancellationSignal: ^BOOL () {
//        BOOL flag = cancel();
//        return flag;
//    }];
//    QNUploadOption *opt = [[QNUploadOption alloc]initWithMime:@"image/png" progressHandler:nil params:dictionary checkCrc:NO cancellationSignal: ^BOOL () {
//        BOOL flag = cancel();
//        return flag;
//    }];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_GETTOKEN];
    [manager POST:urlstring parameters:[NSDictionary dictionaryWithObjectsAndKeys:filename,@"key", nil] success:^(AFHTTPRequestOperation *operation,id responseObj){
            QNUploadManager *upmanager = [[QNUploadManager alloc]init];
            NSData *data = UIImageJPEGRepresentation(imageparams,0.3);
            NSLog(@"%@",operation.responseString);
            [upmanager putData:data key:filename token:operation.responseString complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"info %@",info);
                NSLog(@"resp %@",resp);
                success(resp);
                
            }option:nil];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        
        NSLog(@"response %@",operation.responseString);
            QNUploadManager *upmanager = [[QNUploadManager alloc]init];
        NSData *data = UIImageJPEGRepresentation(imageparams,0.3);
            [upmanager putData:data key:filename token:operation.responseString complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"info %@",info);
                NSLog(@"resp %@",resp);
                NSLog(@"key %@",key);
                success(resp);
            }option:nil];
    }];
}
@end
