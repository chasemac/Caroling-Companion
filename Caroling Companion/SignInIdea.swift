////
////  SignInIdea.swift
////  Caroling Companion
////
////  Created by Chase McElroy on 6/15/17.
////  Copyright © 2017 Chase McElroy. All rights reserved.
////
//
//import Foundation
//
//Here's my Swifty solution for any future onlookers.
//
//1) Create a protocol to handle both login and logout functions:
//
//protocol LoginFlowHandler {
//    func handleLogin()
//    func handleLogout()
//}
//2) Extend said protocol and provide the functionality here for logging out:
//
//extension LoginFlowHandler {
//    
//    func handleLogin(withWindow window: UIWindow?) {
//        
//        if let _ = AppState.shared.currentUserId {
//            //User has logged in before, cache and continue
//            self.showMainApp(withWindow: window)
//        } else {
//            //No user information, show login flow
//            self.showLogin(withWindow: window)
//        }
//    }
//    
//    func handleLogout(withWindow window: UIWindow?) {
//        
//        AppState.shared.signOut()
//        
//        showLogin(withWindow: window)
//    }
//    
//    func showLogin(withWindow window: UIWindow?) {
//        window?.subviews.forEach { $0.removeFromSuperview() }
//        window?.rootViewController = nil
//        window?.rootViewController = R.storyboard.login.instantiateInitialViewController()
//        window?.makeKeyAndVisible()
//    }
//    
//    func showMainApp(withWindow window: UIWindow?) {
//        window?.rootViewController = nil
//        window?.rootViewController = R.storyboard.mainTabBar.instantiateInitialViewController()
//        window?.makeKeyAndVisible()
//    }
//}
//3) Then I can conform my AppDelegate to the LoginFlowHandler protocol, and call handleLogin on startup:
//
//class AppDelegate: UIResponder, UIApplicationDelegate, LoginFlowHandler {
//    
//    var window: UIWindow?
//    
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        
//        window = UIWindow.init(frame: UIScreen.main.bounds)
//        
//        initialiseServices()
//        
//        handleLogin(withWindow: window)
//        
//        return true
//    }
//}
//From here, my protocol extension will handle the logic or determining if the user if logged in/out, and then change the windows rootViewController accordingly!
