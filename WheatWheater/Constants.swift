//
//  Constants.swift
//  WheatWheater
//
//  Created by MingXing on 16/8/13.
//  Copyright © 2016年 MingXing. All rights reserved.
//

import Foundation

//左右界面的背景颜色
let leftControllerAndRightControllerBGColor = UIColor(red: CGFloat(40.0/255.0), green: CGFloat(37.0/255.0), blue: CGFloat(40.0/255.0), alpha: 1.0)

// 用于通知左边controller获取数据更新页面
let LeftControllerTypeChangedNotification = "LeftControllerTypeChangedNotification"



// 定义5-7天天气情况URL
let urlString = Tool.encodeForURL("http://api.k780.com:88/?app=weather.future&weaid=%@&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")

// 定义当前天气URL
let currentUrlString = Tool.encodeForURL("http://api.k780.com:88/?app=weather.today&weaid=%@&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")


