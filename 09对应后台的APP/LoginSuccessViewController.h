//
//  LoginSuccessViewController.h
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginSuccessViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *userName;

-(void) showAlert:(NSString  *)msg;
- (IBAction)exitSystem:(id)sender;

@end
