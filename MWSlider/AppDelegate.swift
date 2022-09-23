//
//  AppDelegate.swift
//  MWSlider
//
//  Created by 최우람 on 2022/09/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = DemoViewController()
        self.window?.makeKeyAndVisible()
        return true
    }

}

