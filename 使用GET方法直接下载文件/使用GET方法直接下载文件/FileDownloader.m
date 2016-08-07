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
@end
@implementation FileDownloader
-(void)downloadFileWithUrlString:(NSString *)urlString{
    NSURL *url=[NSURL URLWithString:urlString];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [NSURLConnection connectionWithRequest:request delegate:self];
}
@end
