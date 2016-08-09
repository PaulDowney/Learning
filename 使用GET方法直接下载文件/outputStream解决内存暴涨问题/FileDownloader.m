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
@property (nonatomic, strong) NSURLConnection* connection;
@end
@implementation FileDownloader
- (void)downloadFileWithUrlString:(NSString*)urlString
{
    //获取服务器文件大小
    self.expectedLength = [self getServerFileSize:urlString];
    //定义一个文件保存的路径
    NSString* filePath = @"/Users/lilinzhu/Desktop/sougou.zip";
    //获取本地文件大小
    self.currentLength = [self getLocalFileSize:filePath];
    NSLog(@"%lld", self.currentLength);

    if (self.currentLength == -1) {
        NSLog(@"已经完成下载,不用下载");
        return;
    }

    NSURL* url = [NSURL URLWithString:urlString];
    NSMutableURLRequest* requestM = [NSMutableURLRequest requestWithURL:url];
    //    [[[NSOperationQueue alloc]init] addOperationWithBlock:^{
    //
    //    }];
    //告诉服务器从哪个位置开始下载
    [requestM setValue:[NSString stringWithFormat:@"bytes=%lld-", self.currentLength] forHTTPHeaderField:@"Range"];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        self.connection = [NSURLConnection connectionWithRequest:requestM delegate:self];
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
 *  HEAD请求 获取服务器文件大小
 *
 *  @param string 文件的URL字符串
 *
 *  @return 返回大小
 */
- (long long)getServerFileSize:(NSString*)string
{
    NSURL* url = [NSURL URLWithString:string];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";
    NSURLResponse* response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];

    return response.expectedContentLength;
}
/**
 *  获取本地文件大小
 *  判断:
    大于服务器文件大小->删掉本地文件 返回大小为0
    小于服务器文件大小->返回本地文件大小
    等于服务器文件大小->返回-1 (已下载完成,不用下载)
 *  @param filePath 本地的文件路径
 *
 *  @return 返回大小
 */
- (long long)getLocalFileSize:(NSString*)filePath
{
    //获取文件管理器
    NSFileManager* manager = [NSFileManager defaultManager];
    //通过文件管理器获取文件一些属性  如果文件不存在 返回值为nil
    NSDictionary* attr = [manager attributesOfItemAtPath:filePath error:NULL];
    //如果 attr不为空 则代表本地文件存在
    if (attr != nil) {
        long long localSize = attr.fileSize;
        if (localSize > self.expectedLength) {
            [manager removeItemAtPath:filePath error:NULL];
            return 0;
        }
        else if (localSize < self.expectedLength) {
            return localSize;
        }
        else {
            return -1;
        }
    }
    return 0;
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
- (void)pauseDownload
{
    [self.connection cancel];
    [self.outputStream close];
    NSLog(@"暂停下载---------------");
}
#pragma mark---NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    NSLog(@"收到响应%@ %lld", response, response.expectedContentLength);
    //    self.expectedLength = response.expectedContentLength;
    NSString* filePath = @"/Users/lilinzhu/Desktop/sougou.zip";
    //初始化输出流 打开管道
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:true];

    [self.outputStream open];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    self.currentLength += data.length;
    float progress = (float)_currentLength / self.expectedLength;
    NSLog(@"收到数据%f %lu", progress, data.length);
    //    [self.dataM appendData:data];
    //    [self saveData:data];
    //往可变的二进制数据里面去拼接二进制数据
    [self.outputStream write:data.bytes maxLength:data.length];
}
- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSLog(@"下载完成");
    //    [self.dataM writeToFile:@"/Users/lilinzhu/Desktop/sougou.zip" atomically:true];
    [self.outputStream close];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"下载出错%@", error);
    [self.outputStream close];
}
@end
