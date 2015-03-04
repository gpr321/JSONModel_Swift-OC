//
//  JSONModelSerializer.swift
//  JSONModelSwift
//
//  Created by mac on 15/2/28.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

import UIKit

@objc protocol JSONModelProtocal{
    /// 获取属性名和字典key之间的映射 key 属性名字 value 字典的 key
    /// return 映射字典
    static func propertyNameDictionaryKeyMap() -> [String:String]
    
    // MARK: 以下方法用于 字典转模型
    /// 对于一些比较特殊的类型重写 set 方法即可把字典对应的类型转化为属性类型
    /// 描述有些数组属性里面装着什么类型的数据
    /// return 映射字典
    static func classInArrayPropertyMap() -> [String: String]
    
    /// 描述模型字典中装着某些key 对应这些字典,对应这什么类型
    /// key : 模型字典的key , value 对应着 多对应的 class
    /// return 映射字典
    static func classInDictionaryPropertyMap() -> [String:[String: String]]?
    
    // MARK: 以下方法用于 模型转字典
    ///  对于特殊类型的数据这套框架无法顺利的提供模型转字典的方法,因此需要开发者自定义
    ///  key: 属性名字 value: 将来要转化为字典的value的值
    ///  :returns:  映射字典
    func customPropertyValue2DictionaryValueMap() -> [String: AnyObject]
    
    ///  在归档的时候指定该方法可以避免某些指定的属性归档
    ///
    ///  :returns: 指定的属性名数组
    static func encodeIgnoreProperties() -> [String]
}

// MARK: JSONModelSerializer - 字典转模型
extension JSONModelSerializer {
    // MARK: 字典转模型
    /// 字典转模型
    public func objectWithDictionary(dict: [String :AnyObject], modelClass: AnyClass) -> AnyObject {
        let obj: AnyObject = modelClass.alloc()
        let modelInfo = self.modelClassInfo(modelClass)
        var propertyMap: [String:String]? = nil
        if modelClass.respondsToSelector("propertyNameDictionaryKeyMap"){
            propertyMap = modelClass.propertyNameDictionaryKeyMap()
        }
        var propertyKey: String
        var resultValue: AnyObject
        // 遍历模型字典
        for (pName,property) in modelInfo!.properties{
            // 找出字典对应的 key
            propertyKey = propertyMap?[pName] ?? pName
            let dictValue: AnyObject? = dict[propertyKey]

            if dictValue == nil || dictValue?.classForCoder === NSNull.classForCoder(){
//                obj.setValue(nil, forKey: pName)
                continue
            }
            resultValue = dictValue!
            let dictValueClassName: NSString = NSStringFromClass(dictValue!.classForCoder)
            if property.type == .CustomClassProperty { // 自定义对象
                resultValue = self.objectWithDictionary(dictValue as! [String : AnyObject], modelClass: property.propertyClass!)
            } else if dictValueClassName.isEqualToString("NSArray"){ // 数组
                resultValue = self.arrayPropertyInArray(dictValue as! [AnyObject], modelClass: modelClass, propertyKey:pName)
            } else if dictValueClassName.isEqualToString("NSDictionary") { // 字典
                resultValue = self.dictionaryPropertyInDictionary(dictValue as! [String: AnyObject], modelClass: modelClass, dictKey: propertyKey)
            }
            obj.setValue(resultValue, forKey: pName)
        }
        return obj
    }
    
    /// 字典中的子字典转换为模型的字典属性
    private func dictionaryPropertyInDictionary(dict: [String: AnyObject],modelClass: AnyClass,dictKey: String) -> [String: AnyObject]{
        if !modelClass.respondsToSelector("classInDictionaryPropertyMap"){
            return dict
        }
        let map = modelClass.classInDictionaryPropertyMap()
        var clsMap: [String: String]? = map![dictKey]
        if clsMap == nil {
            return dict
        }
        var result = [String: AnyObject]()
        for (k,v) in dict{
            let clsStr: String? = clsMap![k]
            if clsStr != nil {
                var cls: AnyClass = self.classFromClassName(clsStr!)
                let vTypeStr = "\(v.classForCoder)"
                if vTypeStr == "NSArray" {
                    result[k] = self.objectArrayWithDictionaryArray(v as! [[String:AnyObject]], modelClass: cls)
                } else if vTypeStr == "NSDictionary" {
                    result[k] = self.objectWithDictionary(v as! [String : AnyObject], modelClass: cls)
                } else {
                    result[k] = v
                }
            } else {
                result[k] = v
            }
        }
        return result
    }
    
    /// 计算数组需要加载什么数据到模型数组属性中
    private func arrayPropertyInArray(array: [AnyObject],modelClass: AnyClass,propertyKey: String) -> [AnyObject]{
        if !modelClass.respondsToSelector("classInArrayPropertyMap"){
            return array
        }
        let className = modelClass.classInArrayPropertyMap()[propertyKey]
        if className == nil {
            return array
        }
        let cls: AnyClass? = self.classFromClassName(className!)
        var resultArray = [AnyObject]()
        for itemDict in array {
            let itemObj: AnyObject = self.objectWithDictionary(itemDict as! [String : AnyObject],modelClass: cls!)
            resultArray.append(itemObj)
        }
        return resultArray
    }
    
    // MARK: 字典数组转模型数组
    /// 字典数组转模型数组
    public func objectArrayWithDictionaryArray(dictionaryArray: [[String:AnyObject]],modelClass: AnyClass) -> [AnyObject]{
        var modelArray = [AnyObject]()
        var obj: AnyObject
        for dict in dictionaryArray{
            obj = self.objectWithDictionary(dict, modelClass: modelClass)
        }
        return modelArray
    }
}

// MARK: JSONModelSerializer - 模型转字典
extension JSONModelSerializer {
    // MARK: 模型转字典
    /// 模型转字典
    public func dictionaryWithObject(model: AnyObject) -> [String: AnyObject]{
        let modelClass: AnyClass = model.classForCoder
        let modelInfo = self.modelClassInfo(modelClass)
        var propertyMap: [String:String]? = nil
        if modelClass.respondsToSelector("propertyNameDictionaryKeyMap") {
            propertyMap = modelClass.propertyNameDictionaryKeyMap()
        }
        var dictionaryKey: String
        var modelDict = [String: AnyObject]()
        for (pName,property) in modelInfo!.properties{
            // 找出字典的key
            dictionaryKey = propertyMap?[pName] ?? pName
            // 找出字典的值
            if let value: AnyObject? = model.valueForKey(pName) {
                if value === nil { continue }
                // 获取调用者指定的字典 value
                let customDictValue: AnyObject? = self.customPropertyValue2DictionaryValueWith(model, propertyName: pName)
                if customDictValue != nil {
                    modelDict[dictionaryKey] = customDictValue!
                    continue
                }
                // 根据属性类型来获取对应的字典 value
                if property.type == .PropertyUnknow {
                    property.type = self.propertyTypeFrom(property, model: model)
                }
                var dictionaryValue: AnyObject?
                dictionaryValue = value
                // TODO : 根据对应的类型来处理
                switch property.type {
                case .KeyValueProperty :           //  直接 KVC 属性
                    dictionaryValue = value
                    break
                case .ArrayProperty :              // 数组属性
                    // TODO : 要判断调用者有没有指定数组中元素的类型
                    let array: [AnyObject] = value as! [AnyObject]
                    var result = [AnyObject]()
                    for item in array{
                        if self.isCustomObject(item) {
                            result.append(self.dictionaryWithObject(item))
                        } else {
                            result.append(item)
                        }
                    }
                    dictionaryValue = result
                    break
                case .DictionaryProperty :         // 字典属性
                    var result = [String: AnyObject]()
                    for (k, v) in value as! [String: AnyObject]{
                        if self.isCustomObject(v) {
                            result[k] = self.dictionaryWithObject(v)
                        } else {
                            result[k] = v
                        }
                    }
                    dictionaryValue = result
                    break
                case .CustomClassProperty :        // 自定义对象属性
                    dictionaryValue = self.dictionaryWithObject(value!);
                    break
                default :
                    dictionaryValue = value;
                    break
                }
                modelDict[dictionaryKey] = dictionaryValue
            }
        }
        return modelDict
    }
    
    // MARK: 获得指定属性最终转化为字典的值
    private func customPropertyValue2DictionaryValueWith(obj: AnyObject, propertyName: String) -> AnyObject? {
        // 如果没有实现对应的函数直接返回取出来的值
        if !obj.respondsToSelector("customPropertyValue2DictionaryValueMap"){
            return nil
        }
        let map = obj.customPropertyValue2DictionaryValueMap()
        if let result: AnyObject = map[propertyName] {
            return result
        }
        // 如果实现的画看该字典中的 key 
        return  nil
    }
    // MARK: 确定属性的类型值 主要用来确定是否 字典 或者 数组,因为自定义类型或者直接keyValue类型已经在 Property 初始化的时候完成了
    /// 通过传入的对象确定属性的值
    private func propertyTypeFrom( property: Property, model: AnyObject ) -> PropertyKeyValueType{
        let value: AnyObject? = model.valueForKey(property.propertyName!)
        let className: NSString = NSStringFromClass(value?.classForCoder)
        if ( className.isEqualToString("NSArray") ){
            return PropertyKeyValueType.ArrayProperty
        } else if ( className.isEqualToString("NSDictionary") ){
            return PropertyKeyValueType.DictionaryProperty
        }
        return PropertyKeyValueType.PropertyUnknow
    }
    
    // MARK: 判断一个对象是否自定义对象
    private func isCustomObject(obj: AnyObject) -> Bool {
        // 主要是根据 该对象是否含有 NS 前缀来判断
        var className = NSStringFromClass(obj.classForCoder)
        if className.hasPrefix("NS"){
            return false
        } else {
            return true
        }
    }
    
    // MARK: 模型数组转字典数组
    /// 模型数组转字典数组
    public func dictionaryArrayFromModelArray(objectArray: [AnyObject]) -> [[String:AnyObject]]{
        var dictArray = [[String:AnyObject]]()
        for itemObj in objectArray{
            dictArray.append(self.dictionaryWithObject(itemObj))
        }
        return dictArray
    }
}

// MARK: JSONModelSerializer主要配置属性 和 初始化方法
public class JSONModelSerializer {
    // MARK: 单例入口
    public static let shareInstance = JSONModelSerializer()
    ///  缓存
    private var modelInfoCache = [String : ModelClassInfo]()
    ///  命名空间
    public var nameSpace : String? = nil
    
    // MARK: 获得模型属性信息
    private func modelClassInfo(cls:AnyClass) -> ModelClassInfo?{
        var className = "\(cls)"
        if nameSpace != nil {
            className = nameSpace! + "." + className
        }
        if let modelInfo = modelInfoCache[className] {
            return modelInfo as ModelClassInfo
        }
        let info = ModelClassInfo()
        info.cls = cls
        self.modelInfo(cls, closure: { (propertyName, attrType) -> () in
            // 构造 property 对象
            var type: PropertyKeyValueType = .PropertyUnknow
            let cls: AnyClass? = self.propertyClassWithTypeString(attrType, type: &type)
            let property = Property()
            property.propertyName = propertyName
            property.propertyTypeString = attrType
            property.propertyClass = cls
            property.type = type
            info.properties[propertyName] = property
        })
        modelInfoCache[className] = info
        return info
    }
    
    // MARK: 根据传入的类名获取类
    private func classFromClassName(var className: String) -> AnyClass{
        if self.nameSpace == nil {
            return NSClassFromString(className)
        }
        className = self.nameSpace! + "." + className
        return NSClassFromString(className)
    }

    // MARK: 根据类型确定属性的class
    private func propertyClassWithTypeString(typeStr:String, inout type: PropertyKeyValueType) -> AnyClass?{
        if typeStr.matchWithRegx("^T[a-zA-Z]$") {
            type = .KeyValueProperty
        }
        // 普通对象类型 或者 Foundation 类型 直接返回空
        if !typeStr.hasPrefix("T@\"") || typeStr.hasPrefix("T@\"NS") {
            return nil
        }
        // 截取字符串找出对应的class
        let nsTypeStr = typeStr as NSString
        let range = nsTypeStr.rangeOfString("T@\"")
        var className = nsTypeStr.substringWithRange(NSMakeRange(range.length, nsTypeStr.length - range.length - 1))
        type = .CustomClassProperty
        return self.classFromClassName(className)
    }
    
    // MARK: 遍历一个类的所有属性的方法
    /// 遍历一个类的所有属性的方法
    func modelInfo(var modelClass:AnyClass,closure:(propertyName:String!,attrType:String!)->()){
        while modelClass !== NSObject.self {
            var count: UInt32 = 0
            let properties = class_copyPropertyList(modelClass, &count)
            var tempP : objc_property_t? = nil
            var cPName : UnsafePointer<Int8>? = nil
            var pName : String? = nil
            var attrType : NSString? = nil
            for(var i : UInt32 = 0; i < count ; i++){
                tempP = properties[Int(i)]
                cPName = property_getName(tempP!)
                pName = String.fromCString(cPName!)!
                attrType = String.fromCString(property_getAttributes(tempP!))
                attrType = attrType!.substringToIndex(attrType!.rangeOfString(",").location)
                closure(propertyName: pName,attrType: attrType as! String)
            }
            free(properties)
            modelClass = modelClass.superclass()!
        }
    }
    
}

// MARK: 归档和解档
extension JSONModelSerializer {
    
    // MARK: 归档方法
    public func encoderObject(obj: AnyObject, encdoer: NSCoder) {
        let cls: AnyClass! = obj.classForCoder
        let info = self.modelClassInfo(cls)
        var ignoreArray: NSArray? = nil
        if cls.respondsToSelector("encodeIgnoreProperties") {
            ignoreArray = cls.encodeIgnoreProperties()
        }
        for (pName, propertyModel) in info!.properties {
            if (ignoreArray != nil && ignoreArray!.containsObject(pName)) {
                continue
            }
            if let pValue: AnyObject = obj.valueForKey(pName) {
                encdoer.encodeObject(pValue, forKey: pName)
            }
        }
    }
    
    // MARK: 解档方法
    public func decoderObject(obj: AnyObject, decoder: NSCoder) {
        let info = self.modelClassInfo(obj.classForCoder)
        for (pName, propertyModel) in info!.properties {
            if let pValue: AnyObject = decoder.decodeObjectForKey(pName) {
                obj.setValue(pValue, forKey: pName)
            }
        }
    }
}

/*************************** 辅助工具方法 *********************************/
// MARK: 内部工具分类
extension String {
    
    func matchWithRegx(regxString: String) -> Bool{
        let nsStr = self as NSString
        var regx = NSRegularExpression(pattern: regxString, options: .CaseInsensitive, error: nil)
        var array = regx!.matchesInString(self as String, options: NSMatchingOptions.ReportProgress, range: NSMakeRange(0, nsStr.length))
        return array.count > 0
    }
}

// MARK: 用来描述一个属性的信息
private class Property {
    var propertyName: String?
    var propertyTypeString: String?
    var propertyClass: AnyClass?    // 属性的 class 只有对于自定义对象才有值
    var type: PropertyKeyValueType = .PropertyUnknow
}

// MARK: 用来控制属性类型
private enum PropertyKeyValueType {
    case PropertyUnknow             // 默认值,用来标志该属性还没确定类型
    case KeyValueProperty           //  直接 KVC 属性
    case ArrayProperty              // 数组属性
    case DictionaryProperty         // 字典属性
    case CustomClassProperty        // 自定义对象属性
}

// MARK: 用来描述一个模型的信息
private class ModelClassInfo{
    var cls : AnyClass?
    /// key : 属性名字 value : 属性信息
    var properties = [String:Property]()
    
}