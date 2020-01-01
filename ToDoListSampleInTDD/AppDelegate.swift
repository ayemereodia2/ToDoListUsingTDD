//
//  AppDelegate.swift
//  ToDoListSampleInTDD
//
//  Created by Ayemere  Odia  on 07/05/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let dataProvider = ItemListDataSource()
        window = UIWindow(frame: UIScreen.main.bounds)
        let initialViewController = UINavigationController(rootViewController: ItemListViewController(dataProvider: dataProvider))
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        return true
    }


}

