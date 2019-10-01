//
//  AppDelegate.swift
//  Todo Notes
//
//  Created by Arslan Khalid on 26/09/2019.
//  Copyright © 2019 Arslan Khalid. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        //print(Realm.Configuration.defaultConfiguration.fileURL)

        do {
            _ = try Realm()
        }catch{
            print("Error initializing new realm \(error)")
        }
        return true
    }
}

