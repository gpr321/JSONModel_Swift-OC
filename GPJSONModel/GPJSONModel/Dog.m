//
//  Dog.m
//  runtimeTest
//
//  Created by mac on 15-2-19.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "Dog.h"
#import "Bone.h"
#import "NSObject+Log.h"

@implementation Dog

- (instancetype)initWithName:(NSString *)name{
    if ( self = [super init] ) {
        self.name = name;
    }
    return self;
}

+ (instancetype)dogWithName:(NSString *)name{
    return [[self alloc] initWithName:name];
}

GPDescription

@end
