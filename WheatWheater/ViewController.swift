//
//  ViewController.swift
//  WheatWheater
//  1, 存在问题手势滑动需要调整
//  Created by MingXing on 16/8/7.
//  Copyright © 2016年 MingXing. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // 创建3个视图控制器的View贴到ViewController中
    var mMainViewController: UINavigationController?
    var mLeftTableViewController: LeftTableViewController?
    var mRightTableViewContrller: RightTableViewController?
    
    let mSpeed_f: CGFloat = 0.6
    
    let mScreenWidth:CGFloat = UIScreen.mainScreen().bounds.width
    let mScreenHeight:CGFloat = UIScreen.mainScreen().bounds.height
    let mSpace: CGFloat = 60  // mainView 预留60px位置
    let mSlideCondition: CGFloat! = UIScreen.mainScreen().bounds.width / 3 // 默认10px进行滑动
    
    
    // MARK: 添加通知
    func addNotificationObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.showMainViewController(_:)), name: AutoLocationNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.showMainViewController(_:)), name: ChooseLocationCityNotification, object: nil)
    }
    
    func showMainViewController(notification:NSNotification) {
        self.showMainView(mMainViewController?.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let rootController = MainViewController()
        mMainViewController = UINavigationController(rootViewController: rootController)
        mLeftTableViewController = LeftTableViewController()
        mRightTableViewContrller = RightTableViewController()
        
        
        self.view.addSubview((mLeftTableViewController?.view)!)
        self.view.addSubview((mRightTableViewContrller?.view)!)
        self.view.addSubview((mMainViewController?.view)!)
        
        self.mRightTableViewContrller?.controller = self
        rootController.controller = self
        
        // 将左右两边的视图隐藏
        self.mLeftTableViewController?.view.hidden = true;
        self.mRightTableViewContrller?.view.hidden = true;
        
        // 添加滑动手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panAction(_:)))
        self.mMainViewController?.view.addGestureRecognizer(pan)
        
        addNotificationObserver()
    }

    
    
    func panAction(sender: UIPanGestureRecognizer) {
        // 获取手指的位置
        let point: CGPoint = sender.translationInView(sender.view!)
//        print("x: \(point.x)")
        
        sender.view?.center = CGPointMake(sender.view!.center.x + point.x * mSpeed_f, sender.view!.center.y)
        sender.setTranslation(CGPointMake(0, 0), inView: sender.view!)
        
        // 右
        if(sender.view!.frame.origin.x > 0) {
            mLeftTableViewController?.view.hidden = false;
            mRightTableViewContrller?.view.hidden = true;
        }
        // 左
        else if (sender.view!.frame.origin.x < 0) {
            mLeftTableViewController?.view.hidden = true;
            mRightTableViewContrller?.view.hidden = false;
        }
        else {
            
        }
        
        // 手指离开屏幕
        if(sender.state == .Ended) {
//            print(".End: \(sender.view!.frame.origin.x)")
            // 满足滑动条件.
            if(fabs(sender.view!.frame.origin.x) >= mSlideCondition) {
                if sender.view!.frame.origin.x > 0 {
                    showLeftView(sender.view)
                } else {
                    showRightView(sender.view)
                }
            } else {
                showMainView(sender.view)
            }
        }
        
    }
    
    // 显示中间视图
    func showMainView(sender: UIView?) {
        UIView.beginAnimations(nil, context: nil)
        sender?.center = CGPointMake(mScreenWidth / 2, mScreenHeight / 2)
        UIView.commitAnimations()
    }
    
    // 显示左边视图
    func showLeftView(sender: UIView?) {
        UIView.beginAnimations(nil, context: nil)
        sender?.center = CGPointMake(mScreenWidth / 2 * 3  - mSpace, mScreenHeight / 2)
        UIView.commitAnimations()
    }
    
    // 显示右边视图
    func showRightView(sender: UIView?) {
        UIView.beginAnimations(nil, context: nil)
        sender?.center = CGPointMake(-(mScreenWidth / 2) + 60, mScreenHeight / 2)
        UIView.commitAnimations()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

