//
//  Student.h
//  runtimeTest
//
//  Created by mac on 15-2-19.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "Person.h"
@class Dog;

@interface Student : Person
@property (nonatomic,assign) NSInteger num;

@property (nonatomic,strong) Dog *dog;

@property (nonatomic,strong) NSArray *pets;

@property (nonatomic,strong) NSDictionary *petsDict;

@property (nonatomic,strong) id emptyProperty;

@property (nonatomic,strong) NSSet *clothes;

@end
