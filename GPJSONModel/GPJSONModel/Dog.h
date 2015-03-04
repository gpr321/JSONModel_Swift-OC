//
//  Dog.h
//  runtimeTest
//
//  Created by mac on 15-2-19.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Dog : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSDictionary *bones;

- (instancetype)initWithName:(NSString *)name;
+ (instancetype)dogWithName:(NSString *)name;

@end
