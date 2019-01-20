//
//  AppDelegate.swift
//  Todoey
//
//  Created by Jasmin Laxamana on 1/3/19.
//  Copyright © 2019 17 B.C. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Using Realm ////
        //print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        do{
               _ = try Realm()
        }catch{
            print("Error initializing new realm, \(error) ")
        }
       
        /////////////////////////
        
        return true
    }


}

