//
//  JGJStudentInfo.h
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJStudentInfo : NSObject

@property  (assign,nonatomic) int uid;
@property  (assign,nonatomic) float shuxue,yuwen;
@property  (strong,nonatomic) NSString  *sex,*name;

-(NSString *)description;

@end
