//
//  AppDelegate.swift
//  Shop
//
//  Created by Pavel Olegovich on 07.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, SplashScreenRouter {
    
    var window: UIWindow?
    let requestFactory = RequestFactory()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        openSplashScreen(window: window)
        
        let mainWindow = UIApplication.shared.windows.first!
        mainWindow.restorationIdentifier = "MainWindow"
        
        return true
    }
    
    static var mainWindow: UIWindow {
        UIApplication.shared.windows.first {
            $0.restorationIdentifier == "MainWindow"
        }!
    }
}

