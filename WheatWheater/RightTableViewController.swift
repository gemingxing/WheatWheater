//
//  RightTableViewController.swift
//  WheatWeather
//
//  Created by vincent on 16/5/7.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit

class RightTableViewController: UITableViewController {
    //需要从本地做存储
    var historyCity:[String]? = Helper.readChaceCity()
    
    let section0Title = ["提醒","设置","支持"]
    let section0Img = ["reminder","setting_right","contact"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = leftControllerAndRightControllerBGColor
        let nib = UINib(nibName: "RightTableViewCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(nib, forCellReuseIdentifier: "reuseIdentifier")
        self.tableView.rowHeight = 70
        self.tableView.separatorStyle = .None
        self.addNotificationObserver()
    }
    
    // 添加通知监听
    func addNotificationObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RightTableViewController.refreshCacheCityData(_:)), name: AutoLocationNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RightTableViewController.refreshCacheCityData(_:)), name: ChooseLocationCityNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RightTableViewController.refreshCacheCityData(_:)), name: DeleteHistoryCityNotification, object: nil)
    }
    
    // 刷新缓存城市
    func refreshCacheCityData(notification:NSNotification) {
        historyCity = Helper.readChaceCity()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 2 + (historyCity == nil ? 0 : historyCity!.count)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! RightTableViewCell
        cell.controller = self.controller
        if indexPath.section == 0 {
            cell.titleLabel.text = section0Title[indexPath.row]
            cell.indicatorImageView.image = UIImage(named: section0Img[indexPath.row])
            cell.deleteImageView.hidden = true
        } else {
            if indexPath.row == 0 {
                cell.titleLabel.text = "添加"
                cell.indicatorImageView.image = UIImage(named: "addcity")
                cell.deleteImageView.hidden = true
            }
            else if indexPath.row == 1 {
                cell.titleLabel.text = "定位"
                cell.indicatorImageView.image = UIImage(named: "city")
                cell.deleteImageView.hidden = true
            }
            else {
                cell.titleLabel.text = historyCity?[indexPath.row - 2]
                cell.indicatorImageView.image = UIImage(named: "city")
                cell.deleteImageView.hidden = false
            }
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat(0)
        } else {
            return CGFloat(30)
        }
    }
    
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let label = UILabel(frame: CGRectMake(0,0,self.view.frame.size.width,0))
            return label
        }else {
            let label = UILabel(frame: CGRectMake(0,0,self.view.frame.size.width,30))
            label.text = "城市管理"
            label.textAlignment = .Center
            label.backgroundColor = UIColor.blackColor()
            label.textColor = UIColor.whiteColor()
            return label
        }
    }
    
    var controller:ViewController?
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                print("添加城市")
                let storyBoard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let addNewCityController = storyBoard.instantiateViewControllerWithIdentifier("AddNewCityTableViewController") as! AddNewCityTableViewController
                self.controller?.presentViewController(addNewCityController, animated: true, completion: { () -> Void in
                    print("显示AddNewCityController回调")
                    print("\(NSThread.currentThread())")
                })
            } else if indexPath.row == 1 {
                print("自动定位")
                NSNotificationCenter.defaultCenter().postNotificationName(AutoLocationNotification, object: nil)
            } else {
                print("历史城市")
                NSNotificationCenter.defaultCenter().postNotificationName(ChooseLocationCityNotification, object: self.historyCity?[indexPath.row - 2])
            }
        }
    }
    
    
    
}
