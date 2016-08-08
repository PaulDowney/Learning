//
//  FileDownloader.m
//  使用GET方法直接下载文件
//
//  Created by Paul_Downey on 16/8/7.
//  Copyright © 2016年 LpL. All rights reserved.
//

#import "FileDownloader.h"

@interface FileDownloader ()<NSURLConnectionDataDelegate>
@property(nonatomic,assign)long long expectedLength;
@property(nonatomic,assign)long long currentLength;
@property(nonatomic,strong)NSMutableData *dataM;
@end
@implementation FileDownloader
-(void)downloadFileWithUrlString:(NSString *)urlString{
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError !=nil||data.length==0) {
            NSLog(@"连接出错%@",connectionError);
            return ;
        }
        [data writeToFile:@"/Users/heima/Desktop/sougou.zip"  atomically:true];
    }];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"收到响应%@ %lld",response,response.expectedContentLength);
    self.expectedLength=response.expectedContentLength;
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    self.currentLength += data.length;
    float  progress=(float )_currentLength/_expectedLength;
    NSLog(@"收到数据%f %lu",progress,data.length);
    [self.dataM appendData:data];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"下载完成");
    [self.dataM writeToFile:@"/Users/lilinzhu/Desktop/sougou.zip" atomically:true];
}
@end
