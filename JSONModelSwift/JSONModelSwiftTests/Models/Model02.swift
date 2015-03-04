//
//  Model02.swift
//  JSONModelSwift
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class Model02: NSObject {
    override class func initialize() {
        let nameSpamce = "JSONModelSwiftTests"
        JSONModelSerializer.shareInstance.nameSpace = nameSpamce
        
    }
    var in_reply_to_user_id: NSString?
    var created_at: NSDate?{
        didSet {
            let fmt = NSDateFormatter()
            fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
            println("--\(created_at)")
            var value: AnyObject = created_at!
            let dateStr = value as! String
            println("---dateStr--\(dateStr)")
            created_at = fmt.dateFromString(dateStr)
            println("--赋值后-\(fmt.stringFromDate(created_at!))")
        }
    }
    
    var favorited: Bool = false
    var in_reply_to_status_id_str: NSString?
    var truncated: NSNumber?
    var retweet_count: NSNumber?
    var possibly_sensitive: NSNumber?
    var in_reply_to_status_id: NSString?
    var in_reply_to_screen_name: NSString?
   
    func getCreated_atStr() -> String {
        let fmt = NSDateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        return fmt.stringFromDate(created_at!)
    }
    
    func customPropertyValue2DictionaryValueMap() -> [String: AnyObject]{
        println("----\(self.getCreated_atStr())")
        return ["created_at": self.getCreated_atStr()]
    }
}


