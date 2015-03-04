//
//  main.m
//  runtimeTest
//
//  Created by mac on 15-2-17.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+Model2Dictionary.h"
#import "NSObject+Dictionary2Model.h"
#import "Student.h"
#import "Dog.h"
#import "Bone.h"
#import <objc/runtime.h>
#import "NSObject+Log.h"
#import "NSArray+Log.h"

void model2Dictioary();
void dictionary2Model();

int main(int argc, const char * argv[]) {
    //    model2Dictioary();
    dictionary2Model();
    return 0;
}

void dictionary2Model(){
    Student *s = [[Student alloc] init];
    s.name = [NSString stringWithFormat:@"%@",@"zhangsan"];
    s.age = 22;
    s.height = 1.75;
    s.num = 55;
    
    Bone *bone1 = [Bone boneWithWeight:10.3];
    Bone *bone2 = [Bone boneWithWeight:10.9];
    Dog *dog1 = [Dog dogWithName:@"dog1"];
    dog1.bones = @{
                   @"bone1" : bone1,
                   @"bone2" : bone2
                   };
    
    Bone *bone3 = [Bone boneWithWeight:20.3];
    Bone *bone4 = [Bone boneWithWeight:20.9];
    Dog *dog2 = [Dog dogWithName:@"dog2"];
    dog2.bones = @{
                   @"bone3" : bone3,
                   @"bone4" : bone4
                   };
    
    s.dog = dog1;
    
    s.pets = @[dog1,dog2];
    s.petsDict = @{
                   @"owner" : @"jack",
                   @"dog1" : dog1,
                   @"dog2" : dog2,
                   @"pets" : @{
                           @"owner" : @"rose",
                           @"pets_dog1" : dog1
                           }
                   };
    s.emptyProperty = nil;
    s.clothes = [NSSet setWithObjects:@"clothes1",@"clothes2", nil];
    NSDictionary *modelDict = [s gp_dictionaryFromModel];
    NSLog(@"%@",s);
    //#warning 测试的时候调整地址并加上分号
    //     [modelDict writeToFile:@"/Users/mac/Desktop/model2Dict.plist" atomically:YES];
    NSLog(@"------------------------");
    s = [Student gp_objectWithDictionary:modelDict];
    NSLog(@"%@",s);
    //    modelDict = [s gp_dictionaryFromModel];
    //#warning 测试的时候调整地址并加上分号
    //     [modelDict writeToFile:@"/Users/mac/Desktop/dict2Model.plist" atomically:YES];
    
}

void model2Dictioary(){
    Student *s = [[Student alloc] init];
    s.name = [NSString stringWithFormat:@"%@",@"zhangsan"];
    s.age = 22;
    s.height = 1.75;
    s.num = 55;
    
    Bone *bone1 = [Bone boneWithWeight:10.3];
    Bone *bone2 = [Bone boneWithWeight:10.9];
    Dog *dog1 = [Dog dogWithName:@"dog1"];
    dog1.bones = @{
                   @"bone1" : bone1,
                   @"bone2" : bone2
                   };
    
    Bone *bone3 = [Bone boneWithWeight:20.3];
    Bone *bone4 = [Bone boneWithWeight:20.9];
    Dog *dog2 = [Dog dogWithName:@"dog2"];
    dog2.bones = @{
                   @"bone3" : bone3,
                   @"bone4" : bone4
                   };
    
    s.dog = dog1;
    
    s.pets = @[dog1,dog2];
    s.petsDict = @{
                   @"dog1" : dog1,
                   @"dog2" : dog2
                   };
    s.emptyProperty = nil;
    s.clothes = [NSSet setWithObjects:@"clothes1",@"clothes2", nil];
    
    //    NSDictionary *modelDict = [s gp_dictionaryFromModel];
    //    [modelDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    //        NSLog(@"%@",[obj class]);
    //    }];
    //    NSLog(@"%@",modelDict);
    //    [modelDict writeToFile:@"/Users/mac/Desktop/test.plist" atomically:YES];
    
}