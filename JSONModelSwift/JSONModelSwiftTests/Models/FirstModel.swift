//
//  FirstModel.swift
//  JSONModelSwift
//
//  Created by mac on 15/3/4.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

class FirstModel: NSObject {
    var coordinates: String?
    var truncated: Bool = true
    var created_at: NSDate?{
        didSet {
            let fmt = NSDateFormatter()
            fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
            var value: AnyObject = created_at!
            let dateStr = value as! String
            created_at = fmt.dateFromString(dateStr)
            println("---\(created_at?.classForCoder)")
        }
    }
    var favorited: Bool = false
    var id_str: String?
    var in_reply_to_user_id_str: String?
    var entities: NSDictionary?
    var source: NSString?
    
    func getCreated_atStr() -> String {
        let fmt = NSDateFormatter()
        fmt.dateFormat = "EEE MM dd HH:mm:ss Z yyyy"
        return fmt.stringFromDate(created_at!)
    }
    
    func customPropertyValue2DictionaryValueMap() -> [String: AnyObject]{
        return ["created_at": self.getCreated_atStr()]
    }
}

class User: NSObject {
    
}
