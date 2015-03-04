//
//  Student.m
//  runtimeTest
//
//  Created by mac on 15-2-19.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "Student.h"
#import "Dog.h"
#import "NSObject+Log.h"

@implementation Student

+ (NSDictionary *)gp_objectClassesInNSDictionaryProperties{
    return @{@"petsDict" : @{
                        @"dog1" : [Dog class],
                        @"dog2" : [Dog class],
                        @"pets" : @{@"pets_dog1" : [Dog class]}
                        }
             };
}

+ (NSDictionary *)gp_objectClassesInArryProperties{
    return @{@"pets" : [Dog class]};
}

GPDescription

@end
