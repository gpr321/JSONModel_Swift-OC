//
//  Model2DictTest.swift
//  JSONModelSwift
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class Model2DictTest: JSONModelSwiftTests {
    override func setUp() {
        super.setUp()
        let nameSpamce = "JSONModelSwiftTests"
        JSONModelSerializer.shareInstance.nameSpace = nameSpamce

    }
    
    override func tearDown() {
        super.tearDown()
    }
    

}
