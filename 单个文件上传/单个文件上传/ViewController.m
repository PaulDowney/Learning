//
//  ViewController.m
//  单个文件上传
//
//  Created by Paul_Downey on 16/8/7.
//  Copyright © 2016年 LpL. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"B5DDA6EEB1F9C7873E872F7E8E00D3E2.jpg" ofType:nil];
    [self uploadWithServerName:@"userfile" andFilePath:path];
}
- (void)uploadWithServerName:(NSString*)serverName andFilePath:(NSString*)filePath
{
    NSURL* url = [NSURL URLWithString:@"http://192.168.43.27/myWeb/php/upload/upload.php"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"multipart/form-data; boundary=itcast" forHTTPHeaderField:@"Content-Type"];

    request.HTTPBody = [self httpBodyWithServerName:@"userfile" filePath:filePath];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
        if (connectionError != nil || data.length == 0) {
            NSLog(@"请求错误%@", connectionError);
            return;
        }
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@", result);
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
