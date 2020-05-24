//
//  AppDelegate.swift
//  MStructure
//
//  Created by Mephrine on 2020/05/21.
//  Copyright © 2020 Mephrine. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    ////// 동영상 전체화면 시, 화면 전환 관련.
    var orientationLock: UIInterfaceOrientationMask = .portrait
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //MARK: Open URL
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            let items = urlComponents?.queryItems
            let scheme = urlComponents?.host
            
            var title: String?
            var urlString: String?
            
            if let data = items {
                for item in data {
                    let key = item.name
                    let value = item.value
                    
                    if key == "title" {
                        title = value
                    } else if key == "url" {
                        urlString = value
                    }
                }
                
                return true
            }
            
            return true
    }

    
    //MARK: 동영상 관련 처리.
    /**
     # supportedInterfaceOrientationsFor
     - Author: Mephrine
     - Date: 20.03.17
     - Parameters:
     - Returns:
     - Note: 디바이스 Orientation이 변경될 때 CallBack.
     */
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let presentedViewController = window?.visibleViewController {
            let className = String(describing: type(of: presentedViewController))
            if ["MPInlineVideoFullscreenViewController", "MPMoviePlayerViewController", "AVFullScreenViewController"].contains(className) {
                orientationLock = .allButUpsideDown
            } else {
                orientationLock = .portrait
            }
        } else {
            orientationLock = .portrait
        }
        
        return orientationLock
    }
    
    // MARK: UISceneSession Lifecycle
    @available (iOS 13, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available (iOS 13, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

