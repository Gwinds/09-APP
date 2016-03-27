//
//  AddInfoViewController.h
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *uid;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *sex;
@property (weak, nonatomic) IBOutlet UITextField *shuxue;
@property (weak, nonatomic) IBOutlet UITextField *yuwen;


@property (weak, nonatomic) IBOutlet UIView *contextView;
- (IBAction)addInfoBtnTap:(id)sender;

- (IBAction)closeKeyboard:(id)sender;

- (IBAction)selectSexBtnTap:(id)sender;
-(void) showAlert:(NSString  *)msg;

@end
