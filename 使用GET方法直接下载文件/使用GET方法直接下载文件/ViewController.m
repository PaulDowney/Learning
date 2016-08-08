//
//  ViewController.m
//  使用GET方法直接下载文件
//
//  Created by Paul_Downey on 16/8/7.
//  Copyright © 2016年 LpL. All rights reserved.
//

#import "ViewController.h"
#import "FileDownloader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    FileDownloader *downloader=[[FileDownloader alloc    ]init];
    [downloader downloadFileWithUrlString:@"http://127.0.0.1/myweb/sougou.zip"];
}
//- (void)demo
//{
//    NSURL *url=[NSURL URLWithString:@"http://127.0.0.1/myweb/sougou.zip"];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
//        if (connectionError !=nil||data.length==0) {
//            NSLog(@"请求出错%@",connectionError);
//            return ;
//        }
//        [data writeToFile:@"/Users/lilinzhu/Desktop/sougou.zip" atomically:true];
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
