//
//  ViewController.m
//  NSURLSession演练
//
//  Created by Paul_Downey on 16/8/8.
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
    [self demo1];
}
- (void)demo2
{
    NSURL* url = [NSURL URLWithString:@"http://127.0.0.1/myweb/php/login/"];
    [[[NSURLSession sharedSession]
          dataTaskWithURL:url
        completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error) {
            if (error != nil || data.length == 0) {
                NSLog(@"%@", error);
                return;
            }
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"%@", result);
        }]resume];
}
- (void)demo1
{
    NSURL* url = [NSURL URLWithString:@"http://127.0.0.1/myweb/php/login/login.php?username=zhangsan&password=zhang"];
    NSURLSession* session = [NSURLSession sharedSession];
    NSURLSessionDataTask* task = [session dataTaskWithURL:url completionHandler:^(NSData* _Nullable data, NSURLResponse* _Nullable response, NSError* _Nullable error) {
        if (error != nil || data.length == 0) {
            NSLog(@"%@", error);
            return;
        }
        id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"%@", result);
    }];
    [task resume];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
