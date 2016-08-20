//
//  LeftTableViewController.swift
//  WheatWeather
//
//  Created by vincent on 16/5/7.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit

class LeftTableViewController: UITableViewController {

    var dataSource = [WeatherInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = leftControllerAndRightControllerBGColor
        
        let nib = UINib(nibName: "LeftTableViewCell", bundle: NSBundle.mainBundle())
        self.tableView.registerNib(nib, forCellReuseIdentifier: "reuseIdentifier")
        
        self.tableView.rowHeight = 100
        
        self.tableView.separatorStyle = .None
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LeftTableViewController.refreshData(_:)), name: LeftControllerTypeChangedNotification, object: nil)

    }
    
    
    func refreshData(sender:NSNotification){
        
        print(sender.userInfo)
        
        if self.dataSource.count > 0 {
            self.dataSource.removeAll()
        }
        
        let info = sender.userInfo!["data"] as! NSArray
        
        for ele in info {
            let dic = ele as! NSDictionary
            let weather = WeatherInfo(dic: dic)
            self.dataSource.append(weather)
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! LeftTableViewCell
        
        let dayWeatherInfo = self.dataSource[indexPath.row]
        cell.dateLabel.text = Tool.retrunNeedDay(dayWeatherInfo.days!)
        cell.weekDayLabel.text = Tool.returnWeekDay(dayWeatherInfo.week!)
        cell.temperatureLabel.text = dayWeatherInfo.temp_low! + "~" + dayWeatherInfo.temp_high!
//        cell.weatherLabel.text = Tool.returnWeatherType(dayWeatherInfo.weather!)
            cell.weatherLabel.text = dayWeatherInfo.weather!
        cell.weatherBgView.backgroundColor = Tool.returnWeatherBGColor(dayWeatherInfo.weather!)
        

        if indexPath.row == 0 {
            
            cell.weekDayLabel.text = "今天"
        }
        
        if indexPath.row == 1 {
           
            cell.weekDayLabel.text = "明天"
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
