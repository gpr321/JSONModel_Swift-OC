//
//  JSONModelSwiftTests.swift
//  JSONModelSwiftTests
//
//  Created by mac on 15/3/2.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit
import XCTest

class JSONModelSwiftTests: XCTestCase {
    
    var file: String?
    var dict: NSDictionary?
    
    var file02: String?
    var array: NSArray?
    
    
    override func setUp() {
        super.setUp()
        if let file = NSBundle(forClass:JSONModelSwiftTests.self).pathForResource("Model01", ofType: "json") {
            self.file = file
            let data = NSData(contentsOfFile: self.file!)
            let dict: NSDictionary? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.allZeros, error: nil) as? NSDictionary
            self.dict = dict
        } else {
            XCTFail("Can't find the test JSON file")
        }
        
        if let file = NSBundle(forClass:JSONModelSwiftTests.self).pathForResource("Model02", ofType: "json") {
            self.file = file
            let data = NSData(contentsOfFile: self.file!)
            let arr: NSArray? = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.allZeros, error: nil) as? NSArray
            self.array = arr
        } else {
            XCTFail("Can't find the test JSON file")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: 获得 json 数据
    func testJSONFile() {
        
        //        println("--------------------------------")
        //        for (k,v) in self.dict! {
        //
        //            println("var \(k): \(v.classForCoder)?")
        //
        //        }
        //        println("--------------------------------")
        
    }
    
}
