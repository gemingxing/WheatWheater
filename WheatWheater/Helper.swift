//
//  Helper.swift
//  WheatWeather
//
//  Created by vincent on 16/5/15.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit

let AutoLocationNotification = "AutoLocationNotification"
let ChooseLocationCityNotification = "ChooseLocationCityNotification"
let DeleteHistoryCityNotification = "DeleteHistoryCityNotification"
//如何存储历史城市记录
//文件读写
let history_city_path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] + "/" + "history_city_path.txt"

//ShareSDK
let ShareSDK_AppKey = "13f51d950af24"

//sina
let Sina_AppKey = "1262130187"
let Sina_AppSecret = "b621c2fa81fba409806bd1b95cbfad82"
let Sina_OAuth_Html = "http://www.baidu.com"

//QQ
let QQ_AppID = "1105477372"
let QQ_AppKey = "qJW9hgLWi6tXNzOl"

//wechat
let weixin_AppID = "wx8571a4f11404252a"
let weixin_AppSecret = "129663c38c2a9302ec7ba3b608a245c8"


let cache_city_key = "cache_city_key"

class Helper: NSObject {
    
    // MARK: 读取缓存城市列表
    class func readChaceCity() -> [String] {
        
        let array = NSArray(contentsOfFile: history_city_path)
        
        if(array == nil) {
            return []
        }
        
        if(array?.count == 0) {
            return []
        }
        
        var citys = [String]()
        for ele in array! {
            citys.append(ele as! String)
        }
        
        return citys
    }
    
    
    // MARK: 插入城市
    class func inseartCity(city:String)->Bool {
        //判断 是否 存在
        var old_citys = Helper.readChaceCity()
        
        if (old_citys.contains(city)) {
            let index = old_citys.indexOf(city)
            old_citys.removeAtIndex(index!)
        }
        //将city插入到数据的最前面
        old_citys.insert(city, atIndex: 0)
        
        let array = NSMutableArray()
        
        for ele in old_citys {
            array.addObject(ele)
        }
        
        return array.writeToFile(history_city_path, atomically: true)
    }
    
    // MARK: 删除城市
    class func deleteCity(city:String) ->Bool {
        //判断 是否 存在
        var old_citys = Helper.readChaceCity()
        
        if old_citys.contains(city) {
            let index = old_citys.indexOf(city)
            old_citys.removeAtIndex(index!)
        }
        
        let array = NSMutableArray()
        
        for ele in old_citys {
            array.addObject(ele)
        }
        
        return array.writeToFile(history_city_path, atomically: true)
    }
    
    
    // 得到缓存城市
    static func cacheCityForKey(cacheCityKey: String) -> String? {
        return NSUserDefaults.standardUserDefaults().valueForKey(cacheCityKey) as? String
    }
    
    // 保存定位后城市
    static func saveLocationCity(city:String!, cityKey:String!) {
        NSUserDefaults.standardUserDefaults().setValue(city, forKey: cityKey)
    }
    
    
}
