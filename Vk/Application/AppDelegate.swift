//
//  AppDelegate.swift
//  Navigation
//
//  Created by Табункин Вадим on 27.02.2022.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var coordinator: MainCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        MainCoordinator.shared.start()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainCoordinator.shared.navigationController
        window?.makeKeyAndVisible()
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = .backgroundColor
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        do {
            try Firebase.Auth.auth().signOut()
        } catch {
            print("Error".localized)
        }
    }
}

