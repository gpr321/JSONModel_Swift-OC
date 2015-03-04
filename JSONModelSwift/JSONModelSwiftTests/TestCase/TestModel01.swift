//
//  TestModel01.swift
//  JSONModelSwift
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit
import XCTest

class TestModel01: JSONModelSwiftTests {
   
    func testModel01() {
        let model01: Model01 =  JSONModelSerializer.shareInstance.objectWithDictionary(self.dict as! [String :AnyObject], modelClass: Model01.self) as! Model01
        let modelDcit: AnyObject = JSONModelSerializer.shareInstance.dictionaryWithObject(model01)
        let b = (modelDcit as! NSDictionary).isEqualToDictionary(self.dict as! [NSObject: AnyObject])
        // 此框架会忽略 字典中的 null 值
        println("-----------------------------------------")
        let dict = modelDcit as! [String: AnyObject]
        for (k,v) in dict {
            let b = ("\(self.dict![k])" == "\(modelDcit[k])")
            XCTAssert(b, "\(k) 值有问题")
        }
        println("-----------------------------------------")
    }
    
}
