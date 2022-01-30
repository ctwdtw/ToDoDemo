//
//  AppDelegate.swift
//  ToDoDemo
//
//  Created by WANG WEI on 2017/7/6.
//  Copyright © 2017年 OneV's Den. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let uikit = false
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if uikit {
            let (vc, _) = ToDoUIComposer.compose(getToDo: ToDoStore.shared.getToDoItems(completionHandler:))
            window?.rootViewController = UINavigationController(rootViewController: vc)
            
        } else {
            let (listView, _) = ToDoSwiftUIComposer.compose(getToDo: ToDoStore.shared.getToDoItems(completionHandler:))
            window?.rootViewController = UIHostingController(rootView: listView)
        }
        
        return true
    }
}

