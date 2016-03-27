//
//  ShowAndEditViewController.h
//  09对应后台的APP
//
//  Created by admin on 16/2/24.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJStudentInfo.h"

@interface ShowAndEditViewController : UIViewController

//接参的属性
@property  (strong,nonatomic)NSMutableArray  *stus;
@property  (strong,nonatomic)JGJStudentInfo  *one;
@property  (assign,nonatomic)NSInteger       index;

//----------------------
@property (assign,nonatomic)BOOL     isChange;
@property (assign,nonatomic)BOOL     isEditing;

@property (weak, nonatomic) IBOutlet UITextField *uidText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UITextField *shuxueText;
@property (weak, nonatomic) IBOutlet UITextField *yuwenText;

@property (weak, nonatomic) IBOutlet UITextField *sex;

@property (weak, nonatomic) IBOutlet UIView *contextView;
@property (weak, nonatomic) IBOutlet UIButton *delBtn;

- (IBAction)editBtnTap:(UIBarButtonItem *)sender;

- (IBAction)selectSexBtnTap:(id)sender;

- (IBAction)deleteItemBtnTap:(id)sender;

- (IBAction)closeKeyBoard:(id)sender;
-(void) checkItemsState;
- (IBAction)editChange:(id)sender;

-(void) performUpdate;
-(void) performDelete;
@end
