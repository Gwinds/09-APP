//
//  SelectViewController.h
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *content;
@property (weak, nonatomic) IBOutlet UITextField *condText;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray  *stus;

- (IBAction)menuBtnTap:(id)sender;

- (IBAction)selectBtnTap:(id)sender;
- (IBAction)closeKeyBoard:(id)sender;
-(void) showAlert:(NSString  *)msg;
@end
