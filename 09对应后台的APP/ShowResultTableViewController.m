//
//  ShowResultTableViewController.m
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import "ShowResultTableViewController.h"
#import "JGJStudentInfo.h"
#import "ShowAndEditViewController.h"
#import "AppDelegate.h"

@interface ShowResultTableViewController ()

@end

@implementation ShowResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.stus.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    
    // Configure the cell...
    JGJStudentInfo *one=[self.stus objectAtIndex:indexPath.row];
    
    cell.textLabel.text=one.name;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"学号:%i",one.uid];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard  *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ShowAndEditViewController  *destVctl=[storyboard instantiateViewControllerWithIdentifier:@"detaileStorBoard"];
    //传参(选中的学生,学生数组用于删除stus及该数据的下标)
    destVctl.stus=self.stus;
    destVctl.index=indexPath.row;
    destVctl.one=[self.stus objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:destVctl animated:YES];
    
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJStudentInfo  *delOne=[self.stus objectAtIndex:indexPath.row];
    
    UIAlertController  *alert=[UIAlertController alertControllerWithTitle:@"提 示" message:@"是否删除(y/n)" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:nil]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //权限认证
        AppDelegate  *delegate=[UIApplication sharedApplication].delegate;
        if(![delegate.loginName isEqualToString:@"root"])
        {
            [self showAlert:@"权限不足,联系管理员"];
            return;
        }
        //--------执行删除
        NSURL  *url=[NSURL URLWithString:@"http://172.16.2.86/haha/login/delete.php"];
        NSMutableURLRequest  *request=[NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        NSString  *args=[NSString stringWithFormat:@"delBtn=确定删除&hiddenValue=uid&hiddenKey=%i",delOne.uid];
        
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
                //删除数据
                [self.stus removeObjectAtIndex:indexPath.row];
                
                //因为此处执行的代码在一个新线程中
                dispatch_async(dispatch_get_main_queue(), ^{
                    //删除单元格
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }
            else
            {
                [self showAlert:@"删除失败!"];
            }
        }];
        //start
        [task resume];
        //-------------over执行删除----------
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) showAlert:(NSString  *)msg
{
    UIAlertController  *alert=[UIAlertController alertControllerWithTitle:@"提 示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
