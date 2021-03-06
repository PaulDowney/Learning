//
//  ViewController.m
//  多文件上传
//
//  Created by Paul_Downey on 16/8/7.
//  Copyright © 2016年 LpL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
/*
 
Content-Type: multipart/form-data; boundary=----WebKitFormBoundaryPBu55l5NAr81Fhu8
 
 
 ------WebKitFormBoundaryPBu55l5NAr81Fhu8
 Content-Disposition: form-data; name="userfile[]"; filename="IMG_2745.jpg"
 Content-Type: image/jpeg
 
 
 ------WebKitFormBoundaryPBu55l5NAr81Fhu8
 Content-Disposition: form-data; name="userfile[]"; filename="IMG_0047.JPG"
 Content-Type: image/jpeg
 
 
 ------WebKitFormBoundaryPBu55l5NAr81Fhu8
 Content-Disposition: form-data; name="status"
 
 皮条钦
 ------WebKitFormBoundaryPBu55l5NAr81Fhu8--
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    NSString *filePath1=[[NSBundle mainBundle]pathForResource:@"20160202213200_tXS4W.jpg" ofType:nil];
    NSString *filePath2=[[NSBundle mainBundle]pathForResource:@"B5DDA6EEB1F9C7873E872F7E8E00D3E2.jpg" ofType:nil];
    NSDictionary *dict=@{@"status":@"皮条钦"};
    
    [self uploadWithServerName:@"userfile[]" filePaths:@[filePath1,filePath2] parameters:dict];
}
- (void)uploadWithServerName:(NSString*)serverName filePaths:(NSArray*)filePaths parameters:(NSDictionary *)parameters
{
    //URL
    NSURL* url = [NSURL URLWithString:@"http://127.0.0.1/myWeb/php/upload/upload-m.php"];
    //可变的请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    //请求的方式
    request.HTTPMethod = @"POST";
    [request setValue:@"multipart/form-data; boundary=----WebKitFormBoundaryPBu55l5NAr81Fhu8" forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [self httpBodyWithServerName:serverName filePaths:filePaths parameters:parameters];
    //发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
        if (connectionError != nil || data.length == 0) {
            NSLog(@"请求错误%@", connectionError);
            return;
        }
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@", result);
    }];
}
- (NSData *)httpBodyWithServerName:(NSString*)serverName filePaths:(NSArray*)filePaths parameters:(NSDictionary*)parameters
{
    NSMutableData* dataM = [NSMutableData data];

    [filePaths enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
        //初始化一个可变的字符串
        NSMutableString* stringM = [NSMutableString string];

        [stringM appendString:@"\r\n------WebKitFormBoundaryPBu55l5NAr81Fhu8\r\n"];
        [stringM appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", serverName, [obj lastPathComponent]];
        [stringM appendString:@"Content-Type: image/jpeg\r\n"];
        [stringM appendString:@"\r\n"];

        [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
        [dataM appendData:[NSData dataWithContentsOfFile:obj]];

    }];
    //拼接文字信息
    [parameters enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
        NSMutableString* stringM = [NSMutableString string];
        [stringM appendString:@"\r\n------WebKitFormBoundaryPBu55l5NAr81Fhu8"];
        [stringM appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        [stringM appendString:@"\r\n"];
        [stringM appendFormat:@"%@\r\n", obj];
        [dataM appendData:[stringM dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    [dataM appendData:[@"--itcast--" dataUsingEncoding:NSUTF8StringEncoding]];
    return [dataM copy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
