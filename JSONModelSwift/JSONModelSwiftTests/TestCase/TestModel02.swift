//
//  TestModel02.swift
//  JSONModelSwift
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit
import XCTest

class TestModel02: JSONModelSwiftTests {
    var  initalDict = [String: AnyObject]()
    
    func testModel02Property() {
        for item in self.array! {
            self.printDict(item as! NSDictionary)
        }
        println("--------------------------------------")
        for (k, v) in  initalDict["entities"] as! NSDictionary {
            println("var \(k): \(v.classForCoder)?")
        }
        println("--------------------------------------")
    }
    
    func printDict(dict: NSDictionary) {
        for (k, v) in dict {
             initalDict[k as! String] = v
        }
    }
    
    func testModel2() {
        let initalDict = self.array![1] as! [String: AnyObject]
        let model02: Model02 =  JSONModelSerializer.shareInstance.objectWithDictionary( initalDict , modelClass: Model02.self) as! Model02
        let model02Dcit: AnyObject = JSONModelSerializer.shareInstance.dictionaryWithObject(model02)
        // 此框架会忽略 字典中的 null 值
        println("-----------------------------------------")
        let dict = model02Dcit as! [String: AnyObject]
        for (k,v) in dict {
            let b = ("\(dict[k])" == "\( initalDict[k])")
            let vd: AnyObject? =  initalDict[k]
//            XCTAssert(b, "\(k) - \(vd)-- \(v) 值有问题")
        }
        println("-----------------------------------------")
    }
}
