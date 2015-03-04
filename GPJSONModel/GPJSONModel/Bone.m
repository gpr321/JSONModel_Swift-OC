//
//  Bone.m
//  runtimeTest
//
//  Created by mac on 15-2-19.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "Bone.h"
#import "NSObject+Log.h"

@implementation Bone

- (instancetype)initWithWeight:(float)weight{
    if ( self = [super init] ) {
        self.weight = weight;
    }
    return self;
}

+ (instancetype)boneWithWeight:(float)weight{
    return [[self alloc] initWithWeight:weight];
}

GPDescription

@end
