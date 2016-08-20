//
//  RightTableViewCell.swift
//  WheatWeather
//
//  Created by vincent on 16/5/15.
//  Copyright © 2016年 Vincent. All rights reserved.
//

import UIKit

class RightTableViewCell: UITableViewCell {
    
    @IBOutlet weak var indicatorImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var deleteImageView: UIImageView!
    
    var controller:UIViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = leftControllerAndRightControllerBGColor
        //        self.selectionStyle = .None
        
        self.deleteImageView.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(RightTableViewCell.deleteAction(_:)))
        self.deleteImageView.addGestureRecognizer(tap)
        
    }
    
    func deleteAction(sender:UITapGestureRecognizer){
        
        let alert = UIAlertController(title: "提示", message: "您是否要删除 \" \(self.titleLabel.text!) \"", preferredStyle: .Alert)
        let cancleAction = UIAlertAction(title: "取消", style: .Cancel) { (action) -> Void in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(cancleAction)
        
        let okAction = UIAlertAction(title: "确定", style: .Default) { (action) -> Void in
            Helper.deleteCity(self.titleLabel.text!)
            NSNotificationCenter.defaultCenter().postNotificationName(DeleteHistoryCityNotification, object: nil)
        }
        alert.addAction(okAction)
        
//    self.controller?.view.window?.rootViewController?.presentViewController(alert, animated: true, completion: {
//            
//            
//        })
        self.controller?.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //        super.touchesBegan(touches, withEvent: event)
    //        self.backgroundColor = UIColor.grayColor()
    //    }
    //    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //        super.touchesEnded(touches, withEvent: event)
    //        self.backgroundColor = leftControllerAndRightControllerBGColor
    //    }
    
}
