//
//  ShowResultTableViewController.h
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShowResultTableViewController : UITableViewController

@property (strong,nonatomic) NSMutableArray  *stus;

-(void) showAlert:(NSString  *)msg;

@end
