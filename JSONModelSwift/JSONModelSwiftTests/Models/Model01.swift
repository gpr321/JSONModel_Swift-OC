//
//  Model01.swift
//  JSONModelSwift
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class Model01: NSObject {
    override class func initialize() {
        let nameSpamce = "JSONModelSwiftTests"
        JSONModelSerializer.shareInstance.nameSpace = nameSpamce

    }
    
    var other: NSArray? //Person
    var newslist: NSArray? // New
    var news: New? // New
    var others: NSArray?
    var str2: NSString?
    var i: NSNumber?
    var b: NSNumber?
    var i16: NSNumber?
    var i64: NSNumber?
    var i8: NSNumber?
    var str1: NSString?
    var d: NSNull?
    var num: NSNull?
    var demo: NSArray?
    var namelist: NSArray?
    var f: NSNumber?
    var info: NSDictionary?
    var i32: NSNumber?
    
    class func classInArrayPropertyMap() -> [String: String] {
        return ["other": "Person", "newslist": "New"];
    }
    
//    class func classInDictionaryPropertyMap() -> [String:[String: String]]? {
//        return ["news": ["tlist": "New"]]
//    }
}

class Person: NSObject {
    var name: String?
}

class NewDesc: NSObject {
    var tname: String?
    var ename: String?
}

class New: NSObject {
    var tlist: NSArray?
    var cname: String?
    var cid: NSNumber?
    
    class func classInArrayPropertyMap() -> [String: String] {
        return ["tlist": "NewDesc"];
    }
}

