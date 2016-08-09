//
//  ViewController.m
//  HEAD请求演练
//
//  Created by Paul_Downey on 16/8/9.
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self demo2];
}
- (void)demo1
{
    NSURL* url = [NSURL URLWithString:@"http://127.0.0.1/myWeb/sougou.zip"];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"HEAD";
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* _Nullable response, NSData* _Nullable data, NSError* _Nullable connectionError) {
        NSLog(@"%@ data=%@", response, data);
    }];
    NSLog(@"哈哈");
}
- (void)demo2
{
    NSURL *url=[NSURL URLWithString:@"http://127.0.0.1/myWeb/sougou.zip"];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL: url];
    request.HTTPMethod=@"HEAD";
    
    NSURLResponse *response;
    NSError *error;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"%@",response);
    NSLog(@"哈哈");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
