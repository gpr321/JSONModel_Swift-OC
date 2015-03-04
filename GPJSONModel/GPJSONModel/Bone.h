//
//  Bone.h
//  runtimeTest
//
//  Created by mac on 15-2-19.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bone : NSObject

@property (nonatomic,assign) float weight;

- (instancetype)initWithWeight:(float)weight;
+ (instancetype)boneWithWeight:(float)weight;

@end
