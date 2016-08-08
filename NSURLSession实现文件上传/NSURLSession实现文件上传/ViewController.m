//
//  ViewController.m
//  NSURLSession实现文件上传
//
//  Created by Paul_Downey on 16/8/8.
//  Copyright © 2016年 LpL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <NSURLSessionDataDelegate>
@property (nonatomic, strong) NSURLSession* session;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)uploadFileWithServerName:(NSString*)serverName filePath:(NSString*)filePath
{
    NSURL* url = [NSURL URLWithString:@""];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    NSData* data = [self httpBodyWithServerName:serverName filePath:filePath];
    [self.session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error){

    }];
}
- (NSData*)httpBodyWithServerName:(NSString*)serverName filePath:(NSString*)filePath
{
    NSMutableData* dataM = [NSMutableData data];

    NSMutableString* stringM = [NSMutableString string];
    [stringM appendString:@"--itcast\r\n"];
    [stringM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", serverName, [filePath lastPathComponent]];
    [stringM appendString:@"Content=Type: image/jpeg\r\n"];
    [stringM appendString:@"\r\n"];

    NSData* data = [stringM dataUsingEncoding:NSUTF8StringEncoding];
    [dataM appendData:data];
    [dataM appendData:[NSData dataWithContentsOfFile:filePath]];

    NSString* string = @"\r\n--itcast--";
    [dataM appendData:[string dataUsingEncoding:NSUTF8StringEncoding]];

    return dataM;
}
#pragma mark- 懒加载
- (NSURLSession*)session
{
    if (_session==nil) {
        _session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    }
    return _session;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
