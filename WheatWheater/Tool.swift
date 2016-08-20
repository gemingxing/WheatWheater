//
//  Tool.swift
//  WheatWeather
//
//  Created by vincent on 16/5/23.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit

enum WeekDays:String {
    case Monday = "周一"
    case Tuesday = "周二"
    case Wednesday = "周三"
    case Thursday = "周四"
    case Friday = "周五"
    case Saturday = "周六"
    case Sunday = "周日"
}

class Tool {
    
    static func encodeForURL(strUrl: String) -> String {
        return strUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    static func returnDate(date:NSDate)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch")
        dateFormatter.dateFormat = "MM.dd"
        return dateFormatter.stringFromDate(date)
    }
    

    class func returnWeekDay(date:NSDate)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch")
        dateFormatter.dateFormat = "EEEE"
        let dateStr = dateFormatter.stringFromDate(date)
        switch dateStr {
            case "Monday":
            return WeekDays.Monday.rawValue
        case "Tuesday":
            return WeekDays.Tuesday.rawValue
        case "Wednesday":
            return WeekDays.Wednesday.rawValue
        case "Thursday":
            return WeekDays.Thursday.rawValue
        case "Friday":
            return WeekDays.Friday.rawValue
        case "Saturday":
            return WeekDays.Saturday.rawValue
        default:
            return WeekDays.Sunday.rawValue
        }
        
    }
    
    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    class func returnWeatherBGColor(weatherType:String)->UIColor {
        let weatherTypePath = NSBundle.mainBundle().pathForResource("weatherBG", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if element as! String == weatherType || weatherType.hasPrefix(element as! String) {
                    let key = element as! String
                    let value = json![key] as! String
                    return Tool.colorWithHexString(value)
                }
            }
        }
        
        return UIColor.grayColor()
    }
    
    class func returnWeatherType(weatherType:String)->String {
        let weatherTypePath = NSBundle.mainBundle().pathForResource("weatherBG", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if  weatherType.hasPrefix(element as! String) {
                    
                    return element as! String
                }
            }
        }
        
        return weatherType
    }
    
    class func returnWeatherImage(weatherType:String)->UIImage? {
        let weatherTypePath = NSBundle.mainBundle().pathForResource("weatherImage", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            
            for element in (json?.allKeys)! {
                if  weatherType.hasPrefix(element as! String) {
                    
                    let value = json![element as! String] as! String
                    return UIImage(named: value)
                    
                }
            }
        }
        
        return nil
    }
    
    class func retrunNeedDay(getDateString:String)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ch")
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = dateFormatter.dateFromString(getDateString)
        let newFormatter = NSDateFormatter()
        newFormatter.locale = NSLocale(localeIdentifier: "ch")
        newFormatter.dateFormat = "MM/dd"
        let dateStr = newFormatter.stringFromDate(date!)
        return dateStr
    }
    
    class func returnWeekDay(getWeekDayString:String)->String {
        if getWeekDayString == "星期一" {
            return "周一"
        }else if getWeekDayString == "星期二" {
            return "周二"
        }else if getWeekDayString == "星期三" {
            return "周三"
        }else if getWeekDayString == "星期四" {
            return "周四"
        }else if getWeekDayString == "星期五" {
            return "周五"
        }else if getWeekDayString == "星期六" {
            return "周六"
        }else {
            return "周日"
        }
    }
    
    class func handleMessageImage(weatherInfo:WeatherInfo)->UIImage? {
        let temp_curr = weatherInfo.temp_curr!
        let temp_curr_number = NSNumberFormatter().numberFromString(temp_curr)
        if Int(temp_curr_number!) > 30 {
            return UIImage(named: "jrgw_normal")
        }
        
        var winp = weatherInfo.winp!
        winp.removeRange(winp.rangeOfString("级")!)
        let winp_number = Int(NSNumberFormatter().numberFromString(winp)!)
        if winp_number > 7 {
            return UIImage(named: "dflx_normal")
        }
        
        let weather = weatherInfo.weather!
        let weatherTypePath = NSBundle.mainBundle().pathForResource("weatherMessage", ofType: "plist")
        if weatherTypePath != nil {
            let json = NSDictionary(contentsOfFile: weatherTypePath!)
            for element in (json?.allKeys)! {
                if  weather.hasPrefix(element as! String) {
                    let value = json![element as! String] as! String
                    return UIImage(named: value)
                }
            }
        }
        
        return nil
    }
    
    
    //将某个view 转成 UIImage
    class func getImageFromView(view:UIView)->UIImage {
        UIGraphicsBeginImageContext(view.bounds.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    
    // 向服务器发送请求获取数据
    static func requestDataWithCity(city: String, completionHandler: (NSData?,NSArray,NSURLResponse?, NSError?) -> Void) {
        
    }
    
    
    
}