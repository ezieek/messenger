//
//  AppDelegate.swift
//  Messenger
//
//  Created by MW on 12/10/19.
//  Copyright © 2019 MW. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()       
        return true
    }
}
