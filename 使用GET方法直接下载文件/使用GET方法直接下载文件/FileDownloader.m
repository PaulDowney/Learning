//
//  FileDownloader.m
//  使用GET方法直接下载文件
//
//  Created by Paul_Downey on 16/8/7.
//  Copyright © 2016年 LpL. All rights reserved.
//

#import "FileDownloader.h"

@interface FileDownloader () <NSURLConnectionDataDelegate>
@property (nonatomic, assign) long long expectedLength;
@property (nonatomic, assign) long long currentLength;
//@property (nonatomic, strong) NSMutableData* dataM;
@property (nonatomic, strong) NSOutputStream* outputStream;
@end
@implementation FileDownloader
- (void)downloadFileWithUrlString:(NSString*)urlString
{
    NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    //    [[[NSOperationQueue alloc]init] addOperationWithBlock:^{
    //
    //    }];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        [NSURLConnection connectionWithRequest:request delegate:self];
        [[NSRunLoop currentRunLoop] run];
    });

    //    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
    //        if (connectionError !=nil||data.length==0) {
    //            NSLog(@"连接出错%@",connectionError);
    //            return ;
    //        }
    //        [data writeToFile:@"/Users/heima/Desktop/sougou.zip"  atomically:true];
    //    }];
}
/**
 *  保存每一次下载的数据
 *  要解决内存峰值过高:每下载一点就保存一点
 *  @param data
 */
- (void)saveData:(NSData*)data
{
    NSString* filePath = @"/Users/lilinzhu/Desktop/sougou.zip";
    //如果该文件不存在,那么这方法初始化出来的对象是nil
    NSFileHandle* handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (handle == nil) {
        //如果handle为nil,则创建文件,并传入data写入到该文件
        [data writeToFile:filePath atomically:true];
    }
    else {
        //将文件句柄移动到文件的最后 以保证数据是从最后面开始写入的
        [handle seekToEndOfFile]; //如果没有这句,就代表每次写入从第0个位置开始
        //如果文件存在,将传入的data写入到文件
        [handle writeData:data];
        //写入完成 要关闭 文件句柄
        [handle closeFile];
    }
}

#pragma mark---NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    NSLog(@"收到响应%@ %lld", response, response.expectedContentLength);
    self.expectedLength = response.expectedContentLength;
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    self.currentLength += data.length;
    float progress = (float)_currentLength / _expectedLength;
    NSLog(@"收到数据%f %lu", progress, data.length);
    //    [self.dataM appendData:data];
    [self saveData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSLog(@"下载完成");
    //    [self.dataM writeToFile:@"/Users/lilinzhu/Desktop/sougou.zip" atomically:true];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"下载出错%@", error);
}
@end
