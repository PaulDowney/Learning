//
//  FileDownloader.h
//  使用GET方法直接下载文件
//
//  Created by Paul_Downey on 16/8/7.
//  Copyright © 2016年 LpL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownloader : NSObject
-(void)downloadFileWithUrlString:(NSString *)urlString;
-(void)pauseDownload;
@end
