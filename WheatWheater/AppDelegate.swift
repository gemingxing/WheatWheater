//
//  AppDelegate.swift
//  WheatWheater
//
//  Created by MingXing on 16/8/7.
//  Copyright © 2016年 MingXing. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 集成shareSDK
        ShareSDK.registerApp(ShareSDK_AppKey,
                             activePlatforms: [
                                SSDKPlatformType.TypeSinaWeibo.rawValue,
                                SSDKPlatformType.TypeWechat.rawValue,
                                SSDKPlatformType.TypeQQ.rawValue],
                             onImport: { (platform: SSDKPlatformType) in
                                switch(platform) {
                                case .TypeQQ :
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                case .TypeWechat:
                                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                                case .TypeSinaWeibo:
                                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                                default:
                                    break
                                }
        }) { (platformType: SSDKPlatformType, appInfo: NSMutableDictionary!) in
            switch platformType {
            case .TypeQQ:
                appInfo.SSDKSetupQQByAppId(QQ_AppID, appKey: QQ_AppKey, authType: SSDKAuthTypeBoth)
            case .TypeSinaWeibo:
                appInfo.SSDKSetupSinaWeiboByAppKey(Sina_AppKey, appSecret: Sina_AppSecret, redirectUri: Sina_OAuth_Html, authType: SSDKAuthTypeBoth)
            case .TypeWechat:
                appInfo.SSDKSetupWeChatByAppId(weixin_AppID, appSecret: weixin_AppSecret)
            default:
                break
            }
        }
        
        
        
        // 配置导航控制器(导航栏透明)
        let navigationBar = UINavigationBar.appearance()
        navigationBar.setBackgroundImage(UIImage(), forBarPosition: .Any, barMetrics: .Default)
        navigationBar.shadowImage = UIImage()
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

