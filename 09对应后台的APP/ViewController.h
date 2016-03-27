//
//  ViewController.h
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<NSURLSessionDataDelegate>

@property (weak, nonatomic) IBOutlet UITextField *uname;
@property (weak, nonatomic) IBOutlet UITextField *upas;

- (IBAction)loginBtnTap:(id)sender;
- (IBAction)registerBtnTap:(id)sender;
- (IBAction)recordBtnTap:(UIButton *)sender;

- (IBAction)closeKeyBoard:(id)sender;

-(void) showAlert:(NSString  *)msg;

@end

