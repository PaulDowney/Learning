//
//  ViewController.m
//  使用GET方法直接下载文件
//
//  Created by Paul_Downey on 16/8/7.
//  Copyright © 2016年 LpL. All rights reserved.
//

#import "FileDownloader.h"
#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIProgressView* progressView;
@property (nonatomic, strong) FileDownloader* downloader;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pauseBtnClick:(id)sender
{
    [self.downloader pauseDownload];
}
- (IBAction)downloadBtnClick:(id)sender
{
    NSLog(@"开始下载---------------");
    self.downloader = [[FileDownloader alloc] init];
    //第一步 通过这个方法传一个block的参数进去
    [self.downloader downloadFileWithUrlString:@"http://127.0.0.1/myweb/sougou.zip" progress:^(float progress) {
        self.progressView.progress = progress;
    }finished:^(BOOL isSuccess, NSError *error) {
        if (isSuccess) {
            NSLog(@"提示用户下载完成");
        } else {
            NSLog(@"%@",error);
        }
    }];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
