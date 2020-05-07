//
//  NetworkViewController.m
//  KnowledgeTips
//
//  Created by 葛聪颖 on 2020/5/7.
//  Copyright © 2020 葛聪颖. All rights reserved.
//

#import "NetworkViewController.h"

@interface NetworkViewController ()<NSURLSessionDataDelegate>

@property (strong, nonatomic) NSMutableData *mData;

@end

@implementation NetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.layer.cornerRadius = 15;
    button.clipsToBounds = YES;
    button.center = self.view.center;
    button.backgroundColor = [UIColor grayColor];
    [button setTitle:@"request" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonClick:(UIButton *)sender {
    [self requestDelegate];
}


#pragma mark - NSURLSession 的优势
/*
 NSURLSession 的优势：
 1.支持 HTTP 2.0 协议
 2.处理下载任务的时候可以直接把数据下载到磁盘
 3.支持后台下载和上传
 4.同一个 session 发送多次请求，只需要建立一次连接（复用了 TCP）
 5.提供了一个全局的 session 并且可以统一配置，使用更加方便
 6.下载的时候可以异步多线程处理
 */


#pragma mark - NSURLSessionTask 即其子类
/*
 NSURLSession 先根据会话对象创建一个请求 task ，然后执行 task 即可
 
 NSURLSessionTask 即其子类
 NSURLSessionTask 是一个抽象类，在使用的时候根据具体情况使用他的子类
 NSURLSessionDataTask 可以发送 GET POST 请求，可以用来上传和下载
 NSURLSessionDownloadTask 发送下载请求，专门用来下载
 NSURLSessionUploadTask 发送上传请求，专门用来上传
 */

#pragma mark - 使用 NSURLSession 发送一个 GET 请求
/*
 1.确定请求路径 【URL】
 2.创建请求对象 【GET】
 3.创建会话对象 【NSURLSession】
 4.更具会话对象创建请求任务 【NSURLSessionDataTask】
 5.执行 Task
 6.得到服务器返回的响应，解析数据
 */
- (void)requestGet {
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *firstTask = [session dataTaskWithURL:url
                                             completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"返回数据解析：\n %@",[NSJSONSerialization JSONObjectWithData:data
                                                              options:kNilOptions
                                                                error:nil]);
    }];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *secondTask = [session dataTaskWithRequest:request
                                                  completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"返回数据解析：\n %@",[NSJSONSerialization JSONObjectWithData:data
                                                              options:kNilOptions
                                                                error:nil]);
    }];
    [firstTask resume];
//    [secondTask resume];
}

#pragma mark - 使用 URLSession 发送 Post 请求
/*
 1.确定请求路径
 2.创建可变的请求对象
 3.修改请求方式为 POST 请求
 4.讲参数转换为二进制参数并且设置请求体
 5.创建会话对象
 6.根据会话对象创建请求任务
 7.执行 Task
 8.d当得到服务器返回，解析数据
 */

- (void)requestPost {
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"name=jack&password=123" dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task_post = [session dataTaskWithRequest:request
                                                 completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"返回数据解析：\n %@",[NSJSONSerialization JSONObjectWithData:data
                                                              options:kNilOptions
                                                                error:nil]);
    }];
    [task_post resume];
}

#pragma mark - 使用代理方法请求
- (void)requestDelegate {
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:self
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
    [task resume];
}

#pragma mark - NSURLSessionDataDelegate
//1.接收到服务器响应的时候调用该方法
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(nonnull NSURLResponse *)response completionHandler:(nonnull void (^)(NSURLSessionResponseDisposition))completionHandler {
    //如果需要知道这个HTTP的所有信息，就需要获得NSURLResponse的子类
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSLog(@"所有响应头信息：%@",httpResponse.allHeaderFields);
    //定义一个容器用于接受服务器返回的数据
    self.mData = [NSMutableData data];
    //注意：和NSURLConnection不同点在于接收到响应信息之后,需要使用completionHandler回调告诉系统应该如何处理服务器返回的数据
    //默认是取消的(NSURLSessionResponseCancel),继续传递数据(NSURLSessionResponseAllow)
    completionHandler(NSURLSessionResponseAllow);
}

//2.接收到服务器返回数据的时候会调用该方法，如果数据较大那么该方法可能会调用多次
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    //拼接服务器返回的数据
    [_mData appendData:data];
}

//3.当请求完成(成功|失败)的时候会调用该方法，如果请求失败，则error有值
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    //解析服务器返回的数据
    //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
    NSLog(@"代理方法返回的响应信息：%@",[NSJSONSerialization JSONObjectWithData:_mData
                                                            options:kNilOptions
                                                              error:nil]);
}


@end
