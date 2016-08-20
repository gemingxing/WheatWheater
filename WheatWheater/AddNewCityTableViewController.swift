//
//  AddNewCityTableViewController.swift
//  WheatWeather
//
//  Created by vincent on 16/6/13.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit

class AddNewCityTableViewController: UITableViewController {
    
    var default_citys:[String]?
    
    func cityWithCityFile() -> [String] {
        var cities:[String] = [String]();
        self.view.backgroundColor = leftControllerAndRightControllerBGColor
        let path = NSBundle.mainBundle().pathForResource("default-city", ofType: "plist")
        let array = NSArray(contentsOfFile: path!)
        for element in array! {
            cities.append(element as! String)
        }
        return cities
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.default_citys = cityWithCityFile()
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.separatorStyle = .None
        
        let headerView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 44))
        headerView.backgroundColor = UIColor.clearColor()
        
        let search_tf = UITextField(frame: CGRectMake(20, 14, self.view.frame.size.width-40, 30))
        search_tf.backgroundColor = UIColor.whiteColor()
        search_tf.layer.cornerRadius = 15
        search_tf.layer.masksToBounds = true
        search_tf.leftView = UIImageView(image: UIImage(named: "search_b"))
        search_tf.leftViewMode = .Always
        search_tf.placeholder = "城市名称或拼音"
        
        headerView.addSubview(search_tf)
        
        self.tableView.tableHeaderView = headerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.default_citys!.count + 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        
        // Configure the cell...
        cell.backgroundColor = leftControllerAndRightControllerBGColor
        cell.textLabel?.textColor = UIColor.whiteColor()

        if indexPath.row == 0 {
            cell.textLabel?.text = "自动定位"
            cell.imageView?.image = UIImage(named: "city")
        } else {
            cell.textLabel?.text = self.default_citys![indexPath.row - 1]
            cell.imageView?.image = nil
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            NSNotificationCenter.defaultCenter().postNotificationName(AutoLocationNotification, object: nil)
        } else {
            NSNotificationCenter.defaultCenter().postNotificationName(ChooseLocationCityNotification, object: self.default_citys![indexPath.row - 1])
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}
