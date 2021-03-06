//
//  AppDelegate.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 28.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        checkPermissions()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        checkPermissions()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        checkPermissions()
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func checkPermissions() {
        let locationStatus = CLLocationManager.authorizationStatus() == .authorizedWhenInUse
        let cameraStatus = AVCaptureDevice.authorizationStatus(for: .video) == .authorized
        
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        if locationStatus && cameraStatus {
            let rootVC = Storyboard.instantiateViewController(withIdentifier: "navController")
            self.window?.rootViewController = rootVC
        } else {
            let rootVC = Storyboard.instantiateViewController(withIdentifier: "PermissionsVC")
            self.window?.rootViewController = rootVC
        }
        
    }

}

