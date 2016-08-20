//
//  MainViewController.swift
//  WheatWeather
//
//  Created by vincent on 16/5/7.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UITableViewController, CLLocationManagerDelegate {
    
    // for CoreLocation
    // 位置管理者
    var locationManager: CLLocationManager?
    // 根据位置解析地名
    var geocoder: CLGeocoder? = CLGeocoder()
//    var tableView: UITableView!
    
    var hud: MBProgressHUD?
    
    var currentCity:String?
    
    let defaultCity:String! = "上海"
    
    // 开始定位
    func startLocation() {
        self.showProgressIndicator("正在定位....")
        if(!CLLocationManager.locationServicesEnabled()) {
            print("定位未打开")
        } else {
            self.locationManager = CLLocationManager()
            // ios8+的定位需要用户授权
            if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0)) {
                // 请求定位授权
                print("请求定位授权!")
                self.locationManager!.requestAlwaysAuthorization()
            }
        }
        // 开始定位
        print("开始定位!")
        self.locationManager!.startUpdatingLocation()
        self.locationManager?.delegate = self
    }
    
    // 定位失败
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if( error.code  == 1 ){
            print("用户选择了不允许..")
        }
        print("error: \(error.debugDescription)")
        self.showProgressIndicator("定位失败, 默认使用'上海'")
        self.currentCity = "上海"
        self.statInit(self.defaultCity)
    }
    
    // 定位成功
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations.count > 0) {
            // 关闭定位
            self.locationManager!.stopUpdatingLocation()
            let locationInfo = locations.last!
            
            // 地名解析
            self.geocoder!.reverseGeocodeLocation(locationInfo, completionHandler: { (clPlaceMarkArray, error) in
                if(clPlaceMarkArray?.count > 0) {
                    let placeM = clPlaceMarkArray![0]
                    print(placeM.addressDictionary)
                    var city = placeM.locality!
                    if(city.containsString("市")) {
                        city.removeRange(city.rangeOfString("市")!)
                    }
                    print("当前城市: \(city)")
                    self.currentCity = city
                    Helper.inseartCity(city)
                    Helper.saveLocationCity(city, cityKey: cache_city_key)
                    NSUserDefaults.standardUserDefaults().setValue(city
                        , forKey: cache_city_key)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.showProgressIndicator("定位成功...正在获取数据")
                        self.statInit(city)
                    })
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initTableView()
        if(self.isLocation()) {
            self.startLocation()
        }else {
            self.statInit(self.currentCity!)
        }
        self.addNotificationObserver()
    }
    
    
    // 是否进行定位
    func isLocation() -> Bool {
        var isLocation:Bool = true;
        self.currentCity = Helper.cacheCityForKey(cache_city_key)
        if(self.currentCity == nil) {
            isLocation = true
        }else {
            isLocation = false
        }
        return isLocation
    }
    
    
    // 添加通知监听
    func addNotificationObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.autoLocationNotification(_:)), name: AutoLocationNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.chooseLocationCityNotification(_:)), name: ChooseLocationCityNotification, object: nil)
    }
    
    // 根据具体地名查询
    func chooseLocationCityNotification(notification: NSNotification) {
        let city = notification.object as! String
        if(self.currentCity == city) {
            return
        }
        self.currentCity = city
        self.requst(city)
        Helper.inseartCity(city)
    }
    
    // 自动定位
    func autoLocationNotification(notification: NSNotification) {
        self.currentCity = nil
        self.startLocation()
    }
    
    // 显示进度标识
    func showProgressIndicator(hint: String) -> Void {
        if(hud == nil) {
            //  print("MBProgressHUD == nil, \(self.view)")
            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        hud?.label.text = hint
    }
    
    // 隐藏
    func hiddenProgressIndicator() -> Void {
        hud?.hidden = true
    }
    
    // 开始初始化
    func statInit(city: String) {
        self.layoutNavigationBar(Tool.returnDate(NSDate()), weekDay: Tool.returnWeekDay(NSDate()), cityName: city)
        self.requst(city)
    }
    
    // 初始化UITableView
    func initTableView() {
//        self.tableView = UITableView(frame: CGRectMake(0, 44, self.view.frame.width, self.view.frame.height))
        self.tableView.hidden = true
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.rowHeight = self.view.frame.height
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "MainTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cellReuseIdentifier")
//        self.view.addSubview(self.tableView)
        self.addMJRefreshHeader()
    }
    
    // 添加MJ刷新头
    func addMJRefreshHeader() {
        self.tableView.mj_header = MJRefreshNormalHeader()
        self.tableView.mj_header.refreshingBlock = { () -> Void in
            self.requst(self.currentCity!)
        }
    }
    
    // 布局UINavigationBar
    func layoutNavigationBar(date:String,weekDay:String,cityName:String) {
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let catogryBarItem = UIBarButtonItem(image: UIImage(named: "category_hover"), style: .Plain, target: self, action: #selector(MainViewController.chooseDateAction(_:)))
        catogryBarItem.imageInsets = UIEdgeInsetsMake(4, 0, 0, 0)
        let dateBarItem = UIBarButtonItem(title: date + "/" + weekDay, style: .Plain, target: self, action: #selector(MainViewController.chooseDateAction(_:)))
        self.navigationItem.leftBarButtonItems = [catogryBarItem,dateBarItem]
        
        let shareBarItem = UIBarButtonItem(image: UIImage(named: "share_small_hover"), style: .Plain, target: self, action: #selector(MainViewController.shareAction(_:)))
        let cityBarItem = UIBarButtonItem(title: cityName, style: .Plain, target: nil, action: nil)
        cityBarItem.tag = 0x0001
        //        cityBarItem.enabled = false
        let settingBarItem = UIBarButtonItem(image: UIImage(named: "settings_hover"), style: .Plain, target: self, action: #selector(MainViewController.settingAction(_:)))
        self.navigationItem.rightBarButtonItems =  [settingBarItem,cityBarItem,shareBarItem]
    }
    
    
    func chooseDateAction(sender:UIBarButtonItem){
        NSLog("chooseDateAction")
    }
    
    var controller:UIViewController?
    
    func shareAction(sender:UIBarButtonItem){
        let actionSheet = UIAlertController(title: "分享天气", message: "", preferredStyle: .ActionSheet)
        let sinaAction = UIAlertAction(title: "分享到新浪微博", style: .Default) { (action) in
            print("\("分享到新浪微博"))")
        }
        let qqFriendAction = UIAlertAction(title: "分享到QQ好友", style: .Default) { (action) in
            print("\("分享到QQ好友"))")
        }
        let qqZoneAction = UIAlertAction(title: "分享到QQ空间", style: .Default) { (action) in
            print("\("分享到QQ空间"))")
        }
        let wechatFriendAction = UIAlertAction(title: "分享到微信好友", style: .Default) { (action) in
            print("\("分享到微信好友"))")
        }
        let wechatCircleAction = UIAlertAction(title: "分享到朋友圈", style: .Default) { (action) in
            print("\("分享到朋友圈"))")
        }
        let cancleAction = UIAlertAction(title: "取消", style: .Cancel) { (action) in
            print("\("取消"))")
        }
        actionSheet.addAction(sinaAction)
        actionSheet.addAction(qqFriendAction)
        actionSheet.addAction(qqZoneAction)
        actionSheet.addAction(wechatFriendAction)
        actionSheet.addAction(wechatCircleAction)
        actionSheet.addAction(cancleAction)

//         self.view.window?.rootViewController?.presentViewController(actionSheet, animated: true, completion: { 
//            print("callback")
//         })
        
        self.controller?.presentViewController(actionSheet, animated: true, completion: { 
            print("callback")
            
        })
        
//        self.presentViewController(actionSheet, animated: true) { 
//            print("callback")
//        }
    }
    
    func settingAction(sender:UIBarButtonItem){
        NSLog("settingAction")
    }
    
    
    func requst(cityName:String){
        //请求七天的天气情况
        let session = NSURLSession.sharedSession()
        
        // 在URL中不能够出现中文等特殊的字符
        let urlString = "http://api.k780.com:88/?app=weather.future&weaid=\(cityName)&&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        
        let url = NSURL(string: urlString!)
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            
            if (error == nil) {
                let weatherInfo = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                let array = weatherInfo!["result"] as! NSArray
                dispatch_async(dispatch_get_main_queue(), {
                    // 发送通知
                    NSNotificationCenter.defaultCenter().postNotificationName(LeftControllerTypeChangedNotification, object: nil, userInfo: ["data":array])
                })
            }
        }
        
        
        // 请求当天天气情况
        // 在URL中不能够出现中文等特殊的字符
        let current_urlString = "http://api.k780.com:88/?app=weather.today&weaid=\(cityName)&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json".stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        let c_session = NSURLSession.sharedSession()
        let current_url = NSURL(string: current_urlString!)
        let current_task = c_session.dataTaskWithURL(current_url!) { (data, response, error) -> Void in
            
            if (error == nil) {
                let weatherInfo = try? NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                let result = weatherInfo!["result"] as! NSDictionary
                print("当前天气状况: \(result)")
                let weather2 = WeatherInfo(dic: result)
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    // 停止刷新
                    self.tableView.mj_header.endRefreshing()
                    // 设置背景颜色
                    self.tableView.backgroundColor = Tool.returnWeatherBGColor(weather2.weather!)
                    // 设置导航栏颜色
                    self.navigationController?.navigationBar.backgroundColor = Tool.returnWeatherBGColor(weather2.weather!)
                    self.uiBarButtonItemWithTag(0x0001)?.title = cityName
                    (self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? MainTableViewCell)?.updateCell(weather2)
                    self.hiddenProgressIndicator()
                    self.tableView.hidden = false
                })
            }
        }
        
        current_task.resume()
        task.resume()
    }
    
    // 根据TAG获取指定的UIBarButtonItem
    func uiBarButtonItemWithTag(tag: Int) -> UIBarButtonItem? {
        for buttonItem in self.navigationItem.rightBarButtonItems! {
            if(buttonItem.tag == tag) {
                return buttonItem
            }
        }
        return nil
    }
    
    
    // UITableView设置
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellReuseIdentifier") as! MainTableViewCell
        return cell
    }
    
    
}
