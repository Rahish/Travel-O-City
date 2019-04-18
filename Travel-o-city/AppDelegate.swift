//
//  AppDelegate.swift
//  Travelocity
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        FirebaseApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication){ }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }
    
    func applicationWillTerminate(_ application: UIApplication) { }
    
    
    //MARK: - Delegate -
    class  func sharedDelegate() -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //MARK: - <Reachbility> -
    class func isInternetConnected() -> Bool
    {
        let reachability = Reachability()
        var isReachable = false
        
        if (reachability?.isReachable)!
        {
            if (reachability?.isReachableViaWiFi)!
            {
                isReachable = true
                print("Reachable via WiFi")
            }
            else
            {
                isReachable = true
                print("Reachable via Cellular")
            }
        }
        else
        {
            isReachable = false
            print("Network not reachable")
        }
        
        return isReachable
    }
}

