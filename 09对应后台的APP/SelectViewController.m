//
//  SelectViewController.m
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import "SelectViewController.h"
#import "ShowResultTableViewController.h"
#import "JGJStudentInfo.h"

#define      BUF_SIZE        128

@interface SelectViewController ()

@end

@implementation SelectViewController
{
    NSMutableData  *recvData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.hidden=YES;
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    recvData=[NSMutableData data];
    self.stus=[[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectBtnTap:(id)sender {
    NSString  *content=[self.content.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(![self.condText.text isEqualToString:@"所有"])
    {
        if(content.length<=0)
        {
            [self showAlert:@"搜索内容不能为空!!!"];
            return;
        }
    }
    //
    [self.stus removeAllObjects];
    
    //-------
    NSURL  *url=[NSURL URLWithString:@"http://172.16.2.86/haha/login/select_phone1.php"];
    NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary  *valueDict=[NSDictionary dictionaryWithObjectsAndKeys:@"all",@"所有",@"uid",@"学号",@"name",@"姓名",@"sex",@"性别",@"shuxue",@"数学",@"yuwen",@"语文",nil];
    //组成参数
    NSString  *args=[NSString stringWithFormat:@"fruits=%@&content=%@",[valueDict objectForKey:self.condText.text],self.content.text];
    [request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSession  *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask  *task=[session dataTaskWithRequest:request];
    [task resume];
}

- (IBAction)closeKeyBoard:(id)sender {
    [self.content resignFirstResponder];
}
- (IBAction)menuBtnTap:(id)sender {
    self.tableView.hidden=!self.tableView.hidden;
}

#pragma   mark --session代理
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    recvData.length=0;
    completionHandler(NSURLSessionResponseAllow);
}
-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [recvData appendData:data];
}
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if(error)
    {
        [self showAlert:[NSString stringWithFormat:@"错误:%@",error.localizedDescription]];
        return;
    }
    //分析及拆分数据进行显示
    NSString  *recvMsg=[[NSString alloc] initWithData:recvData encoding:NSUTF8StringEncoding];
//    NSLog(@">>>%@",recvMsg);
    NSRange  range=[recvMsg rangeOfString:@"(success)"];
    if(range.location==NSNotFound)
    {
        [self showAlert:recvMsg];
    }
    else
    {
        //去除success
        recvMsg=[recvMsg substringFromIndex:range.location+range.length];
        
        int ret,uid;
        float  shuxue,yuwen;
        char   name[BUF_SIZE],sex[BUF_SIZE];
        JGJStudentInfo  *one;
        //拆分数据
        while(1)
        {
            ret=sscanf([recvMsg UTF8String],"%d %s %s %f %f",&uid,name,sex,&shuxue,&yuwen);
            if(ret==-1){
                break;
            }
//            printf("%d %s %s %f %f\n",uid,name,sex,shuxue,yuwen);
            one=[[JGJStudentInfo alloc] init];
            one.uid=uid;
            one.shuxue=shuxue;
            one.yuwen=yuwen;
            one.name=[NSString stringWithCString:name encoding:NSUTF8StringEncoding];
            one.sex=[NSString stringWithCString:sex encoding:NSUTF8StringEncoding];
            [self.stus addObject:one];
            
//            NSLog(@">>%@",one);
            
            //割去一个记示的串  以'\n'为标识
            range=[recvMsg rangeOfString:@"\n"];
            if(range.location!=NSNotFound)
            {
                recvMsg=[recvMsg substringFromIndex:range.location+1];
            }
        }
        //进入表视图显示结果
        [self performSegueWithIdentifier:@"resultSegue" sender:self];
    }
}
//-----传结果数组 以便显示
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"resultSegue"])
    {
        ShowResultTableViewController *dv=[segue destinationViewController];
        dv.stus=self.stus;//传参
    }
}
#pragma   mark --表视图
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell  *cell=[tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"mycell"];
        cell.backgroundColor=[UIColor grayColor];
    }
    NSArray  *data=@[@"所有",@"学号",@"姓名",@"性别",@"数学",@"语文"];
    
    cell.textLabel.text=data[indexPath.row];
    [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray  *data=@[@"所有",@"学号",@"姓名",@"性别",@"数学",@"语文"];
    self.condText.text=data[indexPath.row];
    self.tableView.hidden=YES;
    self.content.text=nil;
}

//----------------
-(void) showAlert:(NSString  *)msg
{
    UIAlertController  *alert=[UIAlertController alertControllerWithTitle:@"提 示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end









