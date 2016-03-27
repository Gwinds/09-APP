//
//  LoginSuccessViewController.m
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import "LoginSuccessViewController.h"
#import "AppDelegate.h"
@interface LoginSuccessViewController ()

@end

@implementation LoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate *ad=[UIApplication sharedApplication].delegate;
    self.navigationItem.leftBarButtonItem.title=ad.loginName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)exitSystem:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void) showAlert:(NSString  *)msg
{
    UIAlertController  *alert=[UIAlertController alertControllerWithTitle:@"提 示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end
