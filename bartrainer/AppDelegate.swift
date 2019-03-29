//
//  AppDelegate.swift
//  bartrainer
//
//  Created by Methira Denthongchai on 10/12/2561 BE.
//  Copyright © 2561 Methira Denthongchai. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AuthenticationServices
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        do {
            try User.load()
            if User.currentUser != nil {
                print("login")
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main")
                UIApplication.shared.keyWindow?.rootViewController = vc
            }
        } catch {
            print(error)
        }

        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
//        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return false
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
              backgroundMusic.shared.audioPlayer?.pause()
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
           backgroundMusic.shared.audioPlayer?.pause()
    }
 


}

