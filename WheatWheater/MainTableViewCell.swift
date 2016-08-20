//
//  MainTableViewCell.swift
//  WheatWheater
//
//  Created by MingXing on 16/8/11.
//  Copyright © 2016年 MingXing. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    
    @IBOutlet weak var mMessageImageView: UIImageView!
    
    @IBOutlet weak var mAnimationImageView: UIImageView!
    
    @IBOutlet weak var mWeatherImageView: UIImageView!
    
    @IBOutlet weak var mWeatherLabel: UILabel!
    
    
    @IBOutlet weak var mCurrent_temp_label: UILabel!
    

    @IBOutlet weak var mRange_temp_label: UILabel!
    
    @IBOutlet weak var mWindImageView: UIImageView!
    
    @IBOutlet weak var mWindLabel: UILabel!
    
    @IBOutlet weak var mHumidityImageView: UIImageView!
    
    @IBOutlet weak var mRangeHumidityLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func updateCell(weather: WeatherInfo?) {
        self.backgroundColor = UIColor.clearColor()
        if(weather != nil) {
            mMessageImageView.image = Tool.handleMessageImage(weather!)
//            mAnimationImageView
            mWeatherImageView.image = Tool.returnWeatherImage(weather!.weather!)
            mWeatherLabel.text = weather!.weather!
            mCurrent_temp_label.text = weather!.temperature_curr
            mRange_temp_label.text = weather!.temp_low! + "ºC~" + weather!.temp_high! + "ºC"
            // 风向图片
            // 风向文本
            mWindLabel.text = weather!.wind
            // 湿度图片
            // 湿度文本
            mRangeHumidityLabel.text = weather!.humi_low! + "~" + weather!.humi_high!
        }
    }
    
}
