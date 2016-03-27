//
//  AddInfoViewController.m
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import "AddInfoViewController.h"
#import "SexSelectTableViewController.h"

@interface AddInfoViewController ()

@end

@implementation AddInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contextView.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addInfoBtnTap:(id)sender {
    if(self.uid.text.length<=0 || self.name.text.length<=0)
    {
        [self showAlert:@"'*'必填项不能为空!!"];
        return;
    }
    NSURL  *url=[NSURL URLWithString:@"http://172.16.2.86/haha/login/insert.php"];
    NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *args=[NSString stringWithFormat:@"uid=%@&name=%@&sex=%@&shuxue=%@&yuwen=%@",self.uid.text,self.name.text,self.sex.text,self.shuxue.text,self.yuwen.text];
    [request setHTTPBody:[args dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask  *task=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error)
        {
            [self showAlert:[NSString stringWithFormat:@"错误:%@",error.localizedDescription]];
            return;
        }
        //分析返回的数据是否成功
        NSString  *recvMsg=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRange  range;
        range=[recvMsg rangeOfString:@"成功"];
        if(range.location==NSNotFound)
        {
            [self showAlert:@"增加数据失败."];
        }
        else
        {
            [self showAlert:@"增加数据成功!"];
        }
    }];
    //启动任务
    [task resume];
}

- (IBAction)closeKeyboard:(id)sender {
    [self.uid resignFirstResponder];
    [self.name resignFirstResponder];
    [self.shuxue resignFirstResponder];
    [self.yuwen resignFirstResponder];
}

- (IBAction)selectSexBtnTap:(id)sender {
    self.contextView.hidden=!self.contextView.hidden;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"sexSegue"])
    {
        SexSelectTableViewController  *dv=[segue destinationViewController];
        dv.delegateCtl=self;
    }
}
-(void) showAlert:(NSString  *)msg
{
    UIAlertController  *alert=[UIAlertController alertControllerWithTitle:@"提 示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
