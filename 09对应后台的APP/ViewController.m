//
//  ViewController.m
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController
{
    BOOL      isRecord;
    NSMutableData *recvData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    recvData=[NSMutableData data];
    isRecord=NO;
    
    //self.uname.text=@"root";
    //self.upas.text=@"123456";
    //查看是否有记录的登陆信息
    NSDictionary  *userInfo=[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    if(userInfo)
    {
        self.uname.text=[[userInfo allKeys] firstObject];
        self.upas.text=[userInfo objectForKey:self.uname.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtnTap:(id)sender {
    NSString  *name,*pas;
    name=[self.uname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pas =[self.upas.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(name.length<=0 || pas.length<=0)
    {
        [self showAlert:@"用户名或密码不能为空!"];
        return;
    }
    //指定访问的URL地址
    NSString  *webPath=@"http://172.16.2.86/haha/LoginandRegister.php";
    NSURL  *url=[NSURL URLWithString:webPath];
    //NSURLRequestUseProtocolCachePolicy使用协议对应的绥存
    //60指60s超时
    NSMutableURLRequest  *request=[[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    //设定传参方法及参数
    [request setHTTPMethod:@"POST"];
    NSString  *args=[NSString stringWithFormat:@"name=%@&btn=登陆&pass=%@",name,pas];
    [request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    //建立会话 启动任务
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask  *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error)
        {
            [self showAlert:[NSString stringWithFormat:@"错误:%@",error.localizedDescription]];
            return;
        }
        //分析数据 是否包含"成功success"关键字
        NSString  *recvMsg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@">>>>%@",recvMsg);
        NSRange  range=[recvMsg rangeOfString:@"( )"];
        if(range.location==NSNotFound)
        {
            [self showAlert:@"用户名不存在或密码错误!"];
//            [self showAlert:recvMsg];
        }
        else
        {
            //记录当前登陆的用户名
            AppDelegate  *app_delegate;
            app_delegate=[UIApplication sharedApplication].delegate;
            app_delegate.loginName=name;
            //检查是否要记录当前的登陆信息
            if(isRecord)
            {
                NSDictionary  *userInfo=[NSDictionary dictionaryWithObjectsAndKeys:pas,name,nil];
                NSUserDefaults  *ud=[NSUserDefaults standardUserDefaults];
                [ud setObject:userInfo forKey:@"userInfo"];
            }
            //成功进入登陆成功后的界面
            [self performSegueWithIdentifier:@"loginSuccess" sender:self];
        }
    }];
    //start task
    [task resume];
}

- (IBAction)registerBtnTap:(id)sender {
    NSString  *name,*pas;
    name=[self.uname.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    pas =[self.upas.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(name.length<=0 || pas.length<=0)
    {
        [self showAlert:@"用户名或密码不能为空!"];
        return;
    }
    //指定访问的URL地址
    NSString  *webPath=@"http://172.16.2.86/haha/LoginandRegister.php";
    NSURL  *url=[NSURL URLWithString:webPath];
    NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:url];
    //设定传参方法及参数
    [request setHTTPMethod:@"POST"];
    NSString  *args=[NSString stringWithFormat:@"name=%@&btn=注册&pass=%@",name,pas];
    [request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    //建立会话 启动任务
    NSURLSession  *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask  *task=[session dataTaskWithRequest:request];
    //start task
    [task resume];

}

- (IBAction)recordBtnTap:(UIButton *)sender {
    isRecord=!isRecord;
    if(isRecord){
        [sender setImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"check" ofType:@"png"]] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:[[NSBundle mainBundle] pathForResource:@"nocheck" ofType:@"png"]] forState:UIControlStateNormal];
    }
}

- (IBAction)closeKeyBoard:(id)sender {
    [self.uname resignFirstResponder];
    [self.upas resignFirstResponder];
}

-(void) showAlert:(NSString  *)msg
{
    UIAlertController  *alert=[UIAlertController alertControllerWithTitle:@"提 示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma   mark --session delegate event
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    recvData.length=0;//清空
    //允许响应
    completionHandler(NSURLSessionResponseAllow);
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [recvData appendData:data];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error){
        [self showAlert:[NSString stringWithFormat:@"错误:%@",error.localizedDescription]];
    }else{
        NSString  *recvMsg=[[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding];
        //分析返回数据是否包含了(success)
        NSRange  range=[recvMsg rangeOfString:@"(success)"];
        if(range.location==NSNotFound)
        {
            [self showAlert:@"用户名非法或已存在"];
        }
        else
        {
            [self showAlert:@"恭喜!注册成功!!"];
        }
    }
}
@end






