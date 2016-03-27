//
//  ShowAndEditViewController.m
//  09对应后台的APP
//
//  Created by admin on 16/2/24.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import "ShowAndEditViewController.h"
#import "SexSelectTableViewController.h"
#import "AppDelegate.h"

@interface ShowAndEditViewController ()

@end

@implementation ShowAndEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contextView.hidden=YES;
    self.isEditing=NO;
    self.uidText.enabled=NO;//不允许改
    self.isChange=NO;
    [self checkItemsState];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.uidText.text=[NSString stringWithFormat:@"%i",self.one.uid];
    self.nameText.text=self.one.name;
    self.sex.text=self.one.sex;
    self.shuxueText.text=[NSString stringWithFormat:@"%g",self.one.shuxue];
    self.yuwenText.text=[NSString stringWithFormat:@"%g",self.one.yuwen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)editBtnTap:(UIBarButtonItem *)sender {
    //权限认证
    AppDelegate  *delegate=[UIApplication sharedApplication].delegate;
    if(![delegate.loginName isEqualToString:@"root"])
    {
        [self showAlert:@"权限不足,联系管理员"];
        return;
    }
    
    self.isEditing=!self.isEditing;
    [self checkItemsState];
    
    if(self.isEditing)
    {
        sender.title=@"Done";
    }
    else
    {
        sender.title=@"Edit";
        if(self.isChange)
        {
            //执行修改
            [self performUpdate];
        }
    }
    self.isChange=NO;
}

-(void)performUpdate
{
    NSURL  *url=[NSURL URLWithString:@"http://172.16.2.86/haha/login/update.php"];
    NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString  *args=[NSString stringWithFormat:@"uid=%@&name=%@&sex=%@&shuxue=%@&yuwen=%@",self.uidText.text,self.nameText.text,self.sex.text,self.shuxueText.text,self.yuwenText.text];
    [request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask  *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error)
        {
            [self showAlert:[NSString stringWithFormat:@"错误:%@",error.localizedDescription]];
            return;
        }
        NSString  *recvMsg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRange  range=[recvMsg rangeOfString:@"成功"];
        if(range.location!=NSNotFound)
        {
            [self showAlert:@"修改成功!"];
            //更新显示的数据
            self.one.name=self.nameText.text;
            self.one.sex=self.sex.text;
            self.one.shuxue=[self.shuxueText.text floatValue];
            self.one.yuwen=[self.yuwenText.text floatValue];
        }
        else
        {
            [self showAlert:@"修改失败!"];
        }
    }];
    //start
    [task resume];
}

- (IBAction)selectSexBtnTap:(id)sender {
    self.contextView.hidden=!self.contextView.hidden;
}
//----------删除---------
- (IBAction)deleteItemBtnTap:(id)sender {
    
    UIAlertController  *alert=[UIAlertController alertControllerWithTitle:@"提 示" message:@"是否删除(y/n)" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self performDelete];//执行删除
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
///-------执行删除动作-------
-(void)performDelete
{
    NSURL  *url=[NSURL URLWithString:@"http://172.16.2.254/haha/login/delete.php"];
    NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString  *args=[NSString stringWithFormat:@"delBtn=确定删除&hiddenValue=uid&hiddenKey=%@",self.uidText.text];
    [request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    //
    NSURLSession  *session=[NSURLSession sharedSession];
    NSURLSessionDataTask  *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error)
        {
            [self showAlert:[NSString stringWithFormat:@"错误:%@",error.localizedDescription]];
            return;
        }
        NSString  *recvMsg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRange  range=[recvMsg rangeOfString:@"成功"];
        if(range.location!=NSNotFound)//success
        {
            [self.stus removeObjectAtIndex:self.index];
            
            //因为此处执行的代码在一个新线程中
            dispatch_async(dispatch_get_main_queue(), ^{
                //返回上一个界面
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self showAlert:@"删除失败!"];
        }
    }];
    //start
    [task resume];
}



- (IBAction)closeKeyBoard:(id)sender {
    [self.uidText resignFirstResponder];
    [self.nameText resignFirstResponder];
    [self.shuxueText resignFirstResponder];
    [self.yuwenText resignFirstResponder];
}

//------性别选择
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"selectSexSegue"])
    {
        SexSelectTableViewController  *dv=[segue destinationViewController];
        dv.delegateCtl=self;
    }
}

-(void)checkItemsState
{
    self.contextView.hidden=YES;
    
//    self.uidText.enabled=self.isEditing;
    self.nameText.enabled=self.isEditing;
    self.shuxueText.enabled=self.isEditing;
    self.yuwenText.enabled=self.isEditing;
    self.sexBtn.enabled=self.isEditing;
    self.delBtn.enabled=self.isEditing;
}

- (IBAction)editChange:(id)sender {
    self.isChange=YES;
}

-(void) showAlert:(NSString  *)msg
{
    UIAlertController  *alert=[UIAlertController alertControllerWithTitle:@"提 示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
