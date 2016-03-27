//
//  JGJStudentInfo.m
//  09对应后台的APP
//
//  Created by admin on 16/2/23.
//  Copyright (c) 2016年 king. All rights reserved.
//

#import "JGJStudentInfo.h"

@implementation JGJStudentInfo

-(NSString *)description
{
    return [NSString stringWithFormat:@"学号:%i 姓名:%@ 性别:%@ 数学:%g 语文:%g",_uid,_name,_sex,_shuxue,_yuwen];
}
@end
